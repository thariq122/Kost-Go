import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui_helpers.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_clients.dart';

class OwnerNotificationScreen extends StatefulWidget {
  final VoidCallback? onAllRead;
  const OwnerNotificationScreen({super.key, this.onAllRead});

  @override
  State<OwnerNotificationScreen> createState() =>
      _OwnerNotificationScreenState();
}

class _OwnerNotifItem {
  final int id;
  final String judul;
  final String pesan;
  final String tipe;
  bool isRead;
  final String createdAt;

  _OwnerNotifItem({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.tipe,
    required this.isRead,
    required this.createdAt,
  });

  factory _OwnerNotifItem.fromJson(Map<String, dynamic> j) => _OwnerNotifItem(
        id: j['id'] is int ? j['id'] : int.parse(j['id'].toString()),
        judul: j['judul'] ?? '',
        pesan: j['pesan'] ?? '',
        tipe: j['tipe'] ?? 'info',
        isRead: j['is_read'] == true || j['is_read'] == 1,
        createdAt: j['created_at'] ?? '',
      );
}

class _OwnerNotificationScreenState extends State<OwnerNotificationScreen> {
  List<_OwnerNotifItem> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userId = context.read<AuthProvider>().userId;
    if (userId <= 0) {
      setState(() => _isLoading = false);
      return;
    }
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
              .map((e) => _OwnerNotifItem.fromJson(e as Map<String, dynamic>))
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
      widget.onAllRead?.call();
    } catch (_) {}
  }

  void _markRead(_OwnerNotifItem item) {
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
        return const Color(0xff818cf8);
    }
  }

  IconData _typeIcon(String t) {
    switch (t) {
      case 'booking':
        return Icons.assignment_rounded;
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
    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: Column(children: [
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
                      if (_unreadCount > 0)
                        Text('$_unreadCount belum dibaca',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: kPrimaryLight, fontSize: 12)),
                    ]),
              ),
              if (_unreadCount > 0)
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
              IconButton(
                icon: const Icon(Icons.refresh_rounded,
                    color: Colors.white54, size: 20),
                onPressed: _loadData,
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildBody(context)),
        ]),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
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
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white38),
              textAlign: TextAlign.center),
          TextButton(
              onPressed: _loadData,
              child: const Text('Coba Lagi',
                  style: TextStyle(color: kPrimaryLight))),
        ]),
      );
    }
    if (_notifications.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.notifications_off_outlined,
              color: Colors.white12, size: 64),
          const SizedBox(height: 16),
          Text('Belum ada notifikasi',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white38)),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      itemCount: _notifications.length,
      itemBuilder: (context, i) => _buildCard(context, _notifications[i]),
    );
  }

  Widget _buildCard(BuildContext context, _OwnerNotifItem notif) {
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
}
