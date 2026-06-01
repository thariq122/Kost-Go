import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'ui_helpers.dart';
import 'booking_history_screen.dart';

enum PaymentMethod { transfer, cash }

class BookingScreen extends StatefulWidget {
  final String namaKost;
  final String harga;
  final String tipe;
  final String foto;
  final String lokasi;

  const BookingScreen({
    super.key,
    required this.namaKost,
    required this.harga,
    required this.tipe,
    required this.foto,
    required this.lokasi,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedDuration = 3;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 3));
  int _currentStep = 0;
  PaymentMethod _paymentMethod = PaymentMethod.transfer;
  XFile? _proofXFile; // cross-platform (web + mobile)
  File? _proofFile; // mobile only, untuk Image.file
  bool _isUploadingImage = false;

  final List<int> _durationOptions = [1, 3, 6, 12];
  final _imagePicker = ImagePicker();

  final TextEditingController _nameController =
      TextEditingController(text: 'Andi Saputra');
  final TextEditingController _phoneController =
      TextEditingController(text: '08123456789');
  final TextEditingController _noteController = TextEditingController();

  String get _totalHarga {
    final hargaNum =
        int.tryParse(widget.harga.replaceAll('Rp ', '').replaceAll('.', '')) ??
            0;
    final total = hargaNum * _selectedDuration;
    final formatted = total.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return 'Rp $formatted';
  }

  String get _formattedDate {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${_selectedDate.day} ${months[_selectedDate.month]} ${_selectedDate.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: kPrimaryColor,
            onPrimary: Colors.white,
            surface: kCardBg,
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isUploadingImage = true);
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
      );
      if (picked != null) {
        setState(() {
          _proofXFile = picked;
          // Di web File() tidak tersedia, hanya pakai XFile
          if (!kIsWeb) {
            _proofFile = File(picked.path);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih foto: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: buildGlassContainer(
          radius: 24,
          padding: const EdgeInsets.all(20),
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
              Text('Pilih Sumber Foto',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildSourceOption(ctx,
                        icon: Icons.camera_alt_rounded,
                        label: 'Kamera',
                        color: kPrimaryColor, onTap: () {
                      Navigator.pop(ctx);
                      _pickImage(ImageSource.camera);
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSourceOption(ctx,
                        icon: Icons.photo_library_rounded,
                        label: 'Galeri',
                        color: const Color(0xff818cf8), onTap: () {
                      Navigator.pop(ctx);
                      _pickImage(ImageSource.gallery);
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption(BuildContext ctx,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label,
                style: Theme.of(ctx).textTheme.labelMedium?.copyWith(
                    color: Colors.white70, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    // Validasi step 2: kalau transfer, wajib ada bukti di step 3
    if (_currentStep < 2) setState(() => _currentStep++);
  }

  void _prevStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  void _submitBooking() {
    // Validasi: transfer wajib upload bukti
    if (_paymentMethod == PaymentMethod.transfer && _proofXFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap upload bukti transfer terlebih dahulu'),
          backgroundColor: Colors.orangeAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: kCardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: kPrimaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: kPrimaryColor.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8))
                ],
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 36),
            ),
            const SizedBox(height: 20),
            Text('Pengajuan Terkirim!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              _paymentMethod == PaymentMethod.transfer
                  ? 'Bukti transfer kamu sudah dikirim. Tunggu konfirmasi pemilik kos dalam 1x24 jam.'
                  : 'Pengajuan sewa kamu diterima. Lakukan pembayaran tunai saat check-in pada $_formattedDate.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const BookingHistoryScreen()),
                    (route) => route.isFirst,
                  );
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('Lihat Status Booking',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: Text('Kembali ke Detail Kos',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
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
            _buildStepIndicator(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: _currentStep == 0
                    ? _buildStep1(context)
                    : _currentStep == 1
                        ? _buildStep2(context)
                        : _buildStep3(context),
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ajukan Sewa',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                Text(widget.namaKost,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    final steps = ['Detail', 'Pembayaran', 'Konfirmasi'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i == _currentStep;
          final isDone = i < _currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        decoration: BoxDecoration(
                          gradient:
                              isActive || isDone ? kPrimaryGradient : null,
                          color: isActive || isDone ? null : Colors.white12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(steps[i],
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: isActive
                                      ? kPrimaryLight
                                      : isDone
                                          ? kPrimaryColor
                                          : Colors.grey,
                                  fontSize: 10,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                    ],
                  ),
                ),
                if (i < steps.length - 1) const SizedBox(width: 8),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── STEP 1: Detail Booking ──────────────────────────────────────────────
  Widget _buildStep1(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: kElevatedCardDecoration(radius: 18),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 72,
                  height: 72,
                  color: kCardBg,
                  child: Image.asset('assets/images/${widget.foto}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_outlined,
                          color: Colors.white12,
                          size: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.namaKost,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.location_on,
                          color: Colors.grey, size: 12),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(widget.lokasi,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                    const SizedBox(height: 6),
                    Text('${widget.harga} /bln',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kPrimaryLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildLabel(context, 'Tanggal Masuk'),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _pickDate,
          child: buildGlassContainer(
            radius: 14,
            height: 52,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      color: kPrimaryLight, size: 18),
                  const SizedBox(width: 12),
                  Text(_formattedDate,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white, fontSize: 14)),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded,
                      color: Colors.grey, size: 18),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildLabel(context, 'Durasi Sewa'),
        const SizedBox(height: 10),
        Row(
          children: _durationOptions.map((d) {
            final isSelected = _selectedDuration == d;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDuration = d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: isSelected ? kPrimaryGradient : null,
                      color: isSelected ? null : kCardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                              isSelected ? Colors.transparent : Colors.white12),
                    ),
                    child: Column(
                      children: [
                        Text('$d',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                        Text('bln',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: isSelected
                                        ? Colors.white70
                                        : Colors.grey,
                                    fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        _buildLabel(context, 'Nama Lengkap'),
        const SizedBox(height: 10),
        _buildTextField(context, _nameController, 'Nama sesuai KTP',
            icon: Icons.person_outline_rounded),
        const SizedBox(height: 16),
        _buildLabel(context, 'Nomor HP'),
        const SizedBox(height: 10),
        _buildTextField(context, _phoneController, 'Nomor aktif WhatsApp',
            icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildLabel(context, 'Catatan (opsional)'),
        const SizedBox(height: 10),
        buildGlassContainer(
          radius: 14,
          child: TextField(
            controller: _noteController,
            maxLines: 3,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Misal: minta kamar lantai 1, dll.',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  // ── STEP 2: Pembayaran ──────────────────────────────────────────────────
  Widget _buildStep2(BuildContext context) {
    final isTransfer = _paymentMethod == PaymentMethod.transfer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, 'Ringkasan Pembayaran'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: kElevatedCardDecoration(radius: 18),
          child: Column(
            children: [
              _buildSummaryRow(context, 'Kos', widget.namaKost,
                  valueStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              _buildSummaryRow(context, 'Tipe', widget.tipe),
              _buildSummaryRow(context, 'Tanggal Masuk', _formattedDate),
              _buildSummaryRow(context, 'Durasi', '$_selectedDuration Bulan'),
              _buildSummaryRow(context, 'Harga/Bulan', widget.harga),
              const Divider(color: Colors.white10, height: 20),
              _buildSummaryRow(context, 'Total Pembayaran', _totalHarga,
                  isTotal: true),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildLabel(context, 'Metode Pembayaran'),
        const SizedBox(height: 12),

        // Transfer Bank
        GestureDetector(
          onTap: () => setState(() => _paymentMethod = PaymentMethod.transfer),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isTransfer ? kPrimaryColor.withValues(alpha: 0.08) : kCardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: isTransfer ? kPrimaryColor : Colors.white12,
                  width: isTransfer ? 1.5 : 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isTransfer
                            ? kPrimaryColor.withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.account_balance_rounded,
                          color: isTransfer ? kPrimaryLight : Colors.grey,
                          size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Transfer Bank',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                          Text('Bayar via transfer ke rekening pemilik',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(
                        isTransfer
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isTransfer ? kPrimaryColor : Colors.grey,
                        size: 20),
                  ],
                ),
                if (isTransfer) ...[
                  const SizedBox(height: 14),
                  const Divider(color: Colors.white10, height: 1),
                  const SizedBox(height: 14),
                  _buildBankDetail(
                      context, 'BCA', '1234567890', 'Budi Hartono'),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Bayar Langsung
        GestureDetector(
          onTap: () => setState(() => _paymentMethod = PaymentMethod.cash),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: !isTransfer
                  ? const Color(0xff22c55e).withValues(alpha: 0.07)
                  : kCardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: !isTransfer ? const Color(0xff22c55e) : Colors.white12,
                  width: !isTransfer ? 1.5 : 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: !isTransfer
                            ? const Color(0xff22c55e).withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.payments_rounded,
                          color: !isTransfer
                              ? const Color(0xff22c55e)
                              : Colors.grey,
                          size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bayar Langsung (Tunai)',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                          Text('Bayar tunai saat tiba di kos',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(
                        !isTransfer
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color:
                            !isTransfer ? const Color(0xff22c55e) : Colors.grey,
                        size: 20),
                  ],
                ),
                if (!isTransfer) ...[
                  const SizedBox(height: 14),
                  const Divider(color: Colors.white10, height: 1),
                  const SizedBox(height: 14),
                  _buildCashInfo(context),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Info box dinamis sesuai metode
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.orangeAccent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: Colors.orangeAccent.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: Colors.orangeAccent, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isTransfer
                      ? 'Lakukan transfer sesuai nominal, lalu upload bukti di langkah berikutnya.'
                      : 'Siapkan uang tunai sebesar $_totalHarga saat check-in pada $_formattedDate.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.orangeAccent, fontSize: 12, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBankDetail(
      BuildContext context, String bank, String noRek, String atasNama) {
    return Column(
      children: [
        _buildBankRow(context, Icons.account_balance_outlined, 'Bank', bank),
        const SizedBox(height: 8),
        _buildBankRow(context, Icons.credit_card_rounded, 'No. Rekening', noRek,
            canCopy: true),
        const SizedBox(height: 8),
        _buildBankRow(context, Icons.badge_outlined, 'Atas Nama', atasNama),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kPrimaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Jumlah Transfer',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey, fontSize: 12)),
              Text(_totalHarga,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kPrimaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBankRow(
      BuildContext context, IconData icon, String label, String value,
      {bool canCopy = false}) {
    return Row(
      children: [
        Icon(icon, color: kPrimaryLight, size: 14),
        const SizedBox(width: 8),
        Text('$label: ',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey, fontSize: 12)),
        Text(value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12)),
        if (canCopy) ...[
          const Spacer(),
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Nomor rekening disalin'),
                  backgroundColor: kPrimaryColor,
                  duration: Duration(seconds: 1)),
            ),
            child:
                const Icon(Icons.copy_rounded, color: kPrimaryLight, size: 14),
          ),
        ],
      ],
    );
  }

  Widget _buildCashInfo(BuildContext context) {
    return Column(
      children: [
        _buildCashRow(context, Icons.calendar_today_rounded, 'Tanggal Check-in',
            _formattedDate),
        const SizedBox(height: 8),
        _buildCashRow(
            context, Icons.payments_rounded, 'Jumlah Tunai', _totalHarga),
        const SizedBox(height: 8),
        _buildCashRow(
            context, Icons.location_on_rounded, 'Lokasi', widget.lokasi),
      ],
    );
  }

  Widget _buildCashRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xff22c55e), size: 14),
        const SizedBox(width: 8),
        Text('$label: ',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey, fontSize: 12)),
        Expanded(
          child: Text(value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  // ── STEP 3: Upload Bukti & Konfirmasi ───────────────────────────────────
  Widget _buildStep3(BuildContext context) {
    final isTransfer = _paymentMethod == PaymentMethod.transfer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload bukti — hanya tampil kalau transfer
        if (isTransfer) ...[
          _buildLabel(context, 'Upload Bukti Transfer'),
          const SizedBox(height: 4),
          Text('Wajib diisi untuk metode transfer bank',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.redAccent, fontSize: 11)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _isUploadingImage ? null : _showImageSourceSheet,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _proofXFile != null
                      ? kPrimaryColor
                      : kPrimaryColor.withValues(alpha: 0.3),
                  width: _proofXFile != null ? 2 : 1.5,
                ),
              ),
              child: _isUploadingImage
                  ? const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor))
                  : _proofXFile != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: kIsWeb
                                  ? Image.network(
                                      _proofXFile!.path,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                          Icons.image_outlined,
                                          color: Colors.white24,
                                          size: 40),
                                    )
                                  : Image.file(_proofFile!, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _proofXFile = null;
                                  _proofFile = null;
                                }),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.close_rounded,
                                      color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_circle_rounded,
                                          color: Color(0xff22c55e), size: 14),
                                      const SizedBox(width: 6),
                                      Text('Foto berhasil dipilih',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 11)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.upload_rounded,
                                  color: kPrimaryLight, size: 28),
                            ),
                            const SizedBox(height: 12),
                            Text('Tap untuk upload bukti transfer',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('Kamera atau Galeri • JPG, PNG maks. 5MB',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.grey, fontSize: 11)),
                          ],
                        ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Bayar langsung — info check-in
        if (!isTransfer) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff22c55e).withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xff22c55e).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xff22c55e).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.payments_rounded,
                      color: Color(0xff22c55e), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bayar Tunai saat Check-in',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Siapkan $_totalHarga pada $_formattedDate',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        _buildLabel(context, 'Konfirmasi Data'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: kCardDecoration(radius: 18),
          child: Column(
            children: [
              _buildSummaryRow(context, 'Nama', _nameController.text),
              _buildSummaryRow(context, 'No. HP', _phoneController.text),
              _buildSummaryRow(context, 'Kos', widget.namaKost,
                  valueStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              _buildSummaryRow(context, 'Masuk', _formattedDate),
              _buildSummaryRow(context, 'Durasi', '$_selectedDuration Bulan'),
              _buildSummaryRow(context, 'Metode',
                  isTransfer ? 'Transfer Bank' : 'Bayar Langsung'),
              const Divider(color: Colors.white10, height: 20),
              _buildSummaryRow(context, 'Total', _totalHarga, isTotal: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.shield_outlined, color: kPrimaryLight, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Data kamu aman dan hanya dibagikan ke pemilik kos.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey, fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final isLastStep = _currentStep == 2;
    final isTransfer = _paymentMethod == PaymentMethod.transfer;
    final canSubmit = !isLastStep ||
        _paymentMethod == PaymentMethod.cash ||
        _proofXFile != null;

    return buildGlassContainer(
      radius: 0,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            GestureDetector(
              onTap: _prevStep,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed:
                  canSubmit ? (isLastStep ? _submitBooking : _nextStep) : null,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: canSubmit ? kPrimaryGradient : null,
                  color: canSubmit ? null : Colors.white12,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLastStep && isTransfer && _proofXFile == null) ...[
                        const Icon(Icons.upload_rounded,
                            color: Colors.white54, size: 16),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        isLastStep ? 'Kirim Pengajuan' : 'Lanjut',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: canSubmit ? Colors.white : Colors.white38,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────
  Widget _buildLabel(BuildContext context, String text) {
    return Text(text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13));
  }

  Widget _buildTextField(
      BuildContext context, TextEditingController controller, String hint,
      {IconData? icon, TextInputType? keyboardType}) {
    return buildGlassContainer(
      radius: 14,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey, fontSize: 13),
          prefixIcon:
              icon != null ? Icon(icon, color: kPrimaryLight, size: 18) : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value,
      {bool isTotal = false, TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey, fontSize: 13)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: valueStyle ??
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isTotal ? kPrimaryLight : Colors.white70,
                        fontWeight:
                            isTotal ? FontWeight.bold : FontWeight.normal,
                        fontSize: isTotal ? 15 : 13)),
          ),
        ],
      ),
    );
  }
}
