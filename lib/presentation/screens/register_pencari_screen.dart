import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'ui_helpers.dart';

class RegisterPencariScreen extends StatefulWidget {
  const RegisterPencariScreen({super.key});

  @override
  State<RegisterPencariScreen> createState() => _RegisterPencariScreenState();
}

class _RegisterPencariScreenState extends State<RegisterPencariScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isAgreed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Anda harus menyetujui Syarat & Ketentuan terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await authProvider.registerPencari(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Akun Pencari Kos berhasil dibuat!'),
            backgroundColor: Colors.teal),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(authProvider.errorMessage ?? 'Registrasi Gagal'),
            backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: kAppBarBg,
        elevation: 0,
        title: Text('Daftar Akun Pencari',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Buat Akun Pencari',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Cari dan sewa kos dengan mudah di KostGo',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[500], fontSize: 14)),
                const SizedBox(height: 28),
                _buildInputField(
                    context,
                    'Nama Lengkap',
                    _nameController,
                    Icons.person_outline,
                    'Masukkan nama lengkap sesuai identitas'),
                const SizedBox(height: 16),
                _buildInputField(
                    context,
                    'Nomor Handphone',
                    _phoneController,
                    Icons.phone_outlined,
                    'Isi dengan nomor handphone yang aktif',
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                _buildInputField(context, 'Email', _emailController,
                    Icons.email_outlined, 'Masukkan email untuk pendaftaran',
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildPasswordField(context, 'Password Baru',
                    _passwordController, _obscurePassword, () {
                  setState(() => _obscurePassword = !_obscurePassword);
                }, 'Minimal 8 karakter angka dan huruf'),
                const SizedBox(height: 16),
                _buildPasswordField(context, 'Konfirmasi Password Baru',
                    _confirmPasswordController, _obscureConfirmPassword, () {
                  setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword);
                }, 'Masukkan kembali password baru', isConfirmField: true),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _isAgreed,
                        activeColor: const Color(0xff14b8a6),
                        checkColor: Colors.black,
                        side: const BorderSide(color: Colors.grey),
                        onChanged: (value) {
                          setState(() => _isAgreed = value ?? false);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  height: 1.4),
                          children: [
                            const TextSpan(
                                text:
                                    'Saya menyatakan bahwa saya telah membaca dan menyetujui '),
                            TextSpan(
                                text: 'Syarat dan Ketentuan',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold)),
                            const TextSpan(text: ' serta '),
                            TextSpan(
                                text: 'Kebijakan Privasi',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold)),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                InkWell(
                  onTap: authProvider.isLoading ? null : _handleRegister,
                  borderRadius: BorderRadius.circular(12),
                  child: Ink(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: authProvider.isLoading ? null : kPrimaryGradient,
                      color: authProvider.isLoading ? Colors.white24 : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text('Daftar',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String label,
      TextEditingController controller, IconData icon, String placeholder,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        buildGlassContainer(
          radius: 12,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600], fontSize: 13),
              prefixIcon: Icon(icon, color: kPrimaryLight, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label tidak boleh kosong';
              }
              if (label == 'Email' && !value.contains('@')) {
                return 'Format email salah';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
      BuildContext context,
      String label,
      TextEditingController controller,
      bool obscure,
      VoidCallback toggleObscure,
      String placeholder,
      {bool isConfirmField = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        buildGlassContainer(
          radius: 12,
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600], fontSize: 13),
              prefixIcon:
                  Icon(Icons.lock_outline, color: kPrimaryLight, size: 20),
              suffixIcon: IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[400], size: 20),
                onPressed: toggleObscure,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label tidak boleh kosong';
              }
              if (!isConfirmField && value.length < 8) {
                return 'Password minimal harus 8 karakter';
              }
              if (isConfirmField && value != _passwordController.text) {
                return 'Konfirmasi password tidak cocok';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
