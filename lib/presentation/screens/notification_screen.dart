import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_clients.dart';
import 'auth_selection_screen.dart';
import 'ui_helpers.dart';

class _NotifItem {
  final int id;
  final String judul;
  final String pesan;
  final String tipe;
  bool isRead;
  final String createdAt;

  _NotifItem({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.tipe,
    required this.isRead,
    required this.createdAt,
  });

  factory _NotifItem.fromJson(Map<String, dynamic> j) => _NotifItem(
        id: j['id'] is int ? j['id'] : int.parse(j['id'].toString()),
        judul: j['judul'] ?? '',
        pesan: j['pesan'] ?? '',
        tipe: j['tipe'] ?? 'info',
        isRead: j['is_read'] == true || j['is_read'] == 1,
        createdAt: j['created_at'] ?? '',
      );
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<_NotifItem> _notifications = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final userId = context.read<AuthProvider>().userId;
    if (userId <= 0) return; // belum login, tidak perlu fetch
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final res = await ApiClient.get(
        ApiEndpoints.getNotifications,
        queryParams: {'user_id': userId.toString()},
      );
      if (res['status'] == 'success') {
        setState(() {
          _notifications = (res['data'] as List<dynamic>)
              .map((e) => _NotifItem.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> _markAllRead() async {
    final userId = context.read<AuthProvider>().userId;
    try {
      await ApiClient.post(ApiEndpoints.readAllNotifications,
          body: {'user_id': userId});
      setState(() {
        for (final n in _notifications) n.isRead = true;
      });
    } catch (_) {}
  }

  void _markRead(_NotifItem item) {
    setState(() => item.isRead = true);
  }

  Color _typeColor(String t) {
    switch (t) {
      case 'booking':
        return kPrimaryColor;
      case 'payment':
        return const Color(0xff22c55e);
      case 'warning':
        return Colors.orangeAccent;
      case 'promo':
        return const Color(0xff9333ea);
      default:
        return Colors.orangeAccent;
    }
  }

  IconData _typeIcon(String t) {
    switch (t) {
      case 'booking':
        return Icons.assignment_turned_in_rounded;
      case 'payment':
        return Icons.payments_rounded;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'promo':
        return Icons.local_offer_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _relativeTime(String createdAt) {
    try {
      final dt = DateTime.parse(createdAt);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      if (diff.inDays == 1) return 'Kemarin';
      if (diff.inDays < 7) return '${diff.inDays} hari lalu';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;

    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              buildGlassContainer(
                radius: 14,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notifikasi',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                      if (isLoggedIn && _unreadCount > 0)
                        Text('$_unreadCount belum dibaca',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: kPrimaryLight, fontSize: 12)),
                    ]),
              ),
              if (isLoggedIn && _unreadCount > 0)
                GestureDetector(
                  onTap: _markAllRead,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: kPrimaryColor.withValues(alpha: 0.3)),
                    ),
                    child: Text('Tandai semua',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: kPrimaryLight,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              if (isLoggedIn)
                IconButton(
                  icon: const Icon(Icons.refresh_rounded,
                      color: Colors.white54, size: 20),
                  onPressed: _loadData,
                ),
            ]),
          ),
          const SizedBox(height: 16),

          // Body
          Expanded(
            child: !isLoggedIn ? _buildGuest(context) : _buildLoggedIn(context),
          ),
        ]),
      ),
    );
  }

  Widget _buildLoggedIn(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: kPrimaryColor));
    }
    if (_error != null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.white24, size: 48),
          const SizedBox(height: 12),
          Text(_error!,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white38)),
          TextButton(
              onPressed: _loadData,
              child: const Text('Coba Lagi',
                  style: TextStyle(color: kPrimaryLight))),
        ]),
      );
    }
    if (_notifications.isEmpty) {
      return _buildEmpty(context);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      itemCount: _notifications.length,
      itemBuilder: (context, i) => _buildCard(context, _notifications[i]),
    );
  }

  Widget _buildCard(BuildContext context, _NotifItem notif) {
    final color = _typeColor(notif.tipe);
    return GestureDetector(
      onTap: () => _markRead(notif),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead ? kCardBg : color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: notif.isRead
                ? Colors.white.withValues(alpha: 0.05)
                : color.withValues(alpha: 0.25),
          ),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_typeIcon(notif.tipe), color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(notif.judul,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: notif.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                          fontSize: 13)),
                ),
                if (!notif.isRead)
                  Container(
                      width: 8,
                      height: 8,
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle)),
              ]),
              const SizedBox(height: 4),
              Text(notif.pesan,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey, fontSize: 12, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text(_relativeTime(notif.createdAt),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white30, fontSize: 11)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildGuest(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kPrimaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(
                  color: kPrimaryColor.withValues(alpha: 0.2), width: 1.5),
            ),
            child: const Icon(Icons.notifications_off_outlined,
                color: kPrimaryLight, size: 48),
          ),
          const SizedBox(height: 24),
          Text('Masuk untuk lihat notifikasi',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17)),
          const SizedBox(height: 10),
          Text(
            'Notifikasi booking, pembayaran, dan promo khusus hanya tersedia setelah kamu masuk.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AuthSelectionScreen(
                      onLoginSuccess: () => Navigator.pop(context),
                    ),
                  ),
                );
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Text('Masuk Sekarang',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.notifications_off_outlined,
            color: Colors.white12, size: 64),
        const SizedBox(height: 16),
        Text('Belum ada notifikasi',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white38, fontSize: 15)),
        const SizedBox(height: 8),
        Text('Notifikasi booking dan pembayaran\nakan muncul di sini.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white24, fontSize: 13)),
      ]),
    );
  }
}
