import 'package:flutter/material.dart';
import 'ui_helpers.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class ChatScreen extends StatefulWidget {
  final String namaKost;
  final String namaPemilik;

  const ChatScreen({
    super.key,
    required this.namaKost,
    required this.namaPemilik,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    const ChatMessage(
      text:
          'Halo, saya tertarik dengan kos ini. Apakah masih ada kamar kosong?',
      isMe: true,
      time: '10:00',
    ),
    const ChatMessage(
      text: 'Halo! Masih ada 2 kamar kosong. Mau yang tipe apa?',
      isMe: false,
      time: '10:02',
    ),
    const ChatMessage(
      text: 'Yang ada AC dan kamar mandi dalam ada tidak?',
      isMe: true,
      time: '10:03',
    ),
    const ChatMessage(
      text:
          'Ada, harganya Rp 950.000/bulan. Fasilitas lengkap: AC, WiFi, kamar mandi dalam, kasur springbed.',
      isMe: false,
      time: '10:05',
    ),
    const ChatMessage(
      text: 'Boleh survei dulu tidak? Kapan bisa?',
      isMe: true,
      time: '10:06',
    ),
    const ChatMessage(
      text:
          'Bisa, silakan datang hari Sabtu atau Minggu jam 09.00–17.00. Hubungi saya dulu ya sebelum datang.',
      isMe: false,
      time: '10:08',
    ),
  ];

  final List<String> _quickReplies = [
    'Apakah masih ada kamar?',
    'Berapa harganya?',
    'Boleh survei dulu?',
    'Fasilitas apa saja?',
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final now = TimeOfDay.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add(ChatMessage(text: text.trim(), isMe: true, time: timeStr));
      _inputController.clear();
    });

    // Scroll ke bawah
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulasi balasan otomatis
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text: 'Terima kasih pesannya! Saya akan segera membalas.',
          isMe: false,
          time: timeStr,
        ));
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final showAvatar =
                      !msg.isMe && (index == 0 || _messages[index - 1].isMe);
                  return _buildBubble(context, msg, showAvatar);
                },
              ),
            ),
            _buildQuickReplies(context),
            _buildInputBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return buildGlassContainer(
      radius: 0,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
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
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: kPrimaryGradient,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: kCardBg,
              child: Icon(Icons.person_rounded, color: kPrimaryLight, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.namaPemilik,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          color: Color(0xff22c55e), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 5),
                    Text('Online',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xff22c55e), fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          buildGlassContainer(
            radius: 12,
            child: IconButton(
              icon: const Icon(Icons.info_outline_rounded,
                  color: Colors.white70, size: 20),
              onPressed: () => _showKostInfo(context),
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(BuildContext context, ChatMessage msg, bool showAvatar) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMe) ...[
            if (showAvatar)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 16),
              )
            else
              const SizedBox(width: 30),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.72),
                  decoration: BoxDecoration(
                    gradient: msg.isMe ? kPrimaryGradient : null,
                    color: msg.isMe ? null : kCardBg,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(msg.isMe ? 18 : 4),
                      bottomRight: Radius.circular(msg.isMe ? 4 : 18),
                    ),
                    border: msg.isMe
                        ? null
                        : Border.all(
                            color: Colors.white.withValues(alpha: 0.07)),
                  ),
                  child: Text(msg.text,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white, fontSize: 13, height: 1.4)),
                ),
                const SizedBox(height: 3),
                Text(msg.time,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white24, fontSize: 10)),
              ],
            ),
          ),
          if (msg.isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildQuickReplies(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _quickReplies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _sendMessage(_quickReplies[index]),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: kPrimaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPrimaryColor.withValues(alpha: 0.3)),
              ),
              child: Text(_quickReplies[index],
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: kPrimaryLight,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return buildGlassContainer(
      radius: 0,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: buildGlassContainer(
              radius: 24,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: _sendMessage,
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded,
                        color: Colors.grey, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur lampiran segera hadir'),
                          backgroundColor: kPrimaryColor,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessage(_inputController.text),
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                gradient: kPrimaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: kPrimaryColor.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _showKostInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: buildGlassContainer(
          radius: 28,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.home_work_rounded,
                  color: kPrimaryLight, size: 36),
              const SizedBox(height: 12),
              Text(widget.namaKost,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 4),
              Text('Pemilik: ${widget.namaPemilik}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: Colors.orangeAccent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined,
                        color: Colors.orangeAccent, size: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Jaga keamanan data pribadimu. Jangan bagikan nomor rekening atau password ke siapapun.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.orangeAccent,
                            fontSize: 12,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
