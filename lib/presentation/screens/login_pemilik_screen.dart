import 'package:flutter/material.dart';
import 'register_pemilik_screen.dart';
import 'forgot_password_screen.dart'; // Pastikan import halaman lupa password
import 'ui_helpers.dart';

class LoginPemilikScreen extends StatelessWidget {
  const LoginPemilikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Aplikasi Berbingkai Teal (Seragam)
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: buildGlassContainer(
                  radius: 50,
                  padding: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.home_work_rounded,
                    size: 60,
                    color: kPrimaryLight,
                  ),
                ),
              ),
            ),

            Text(
              'Login Pemilik Kos',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            _buildTextField(context, 'Nomor Handphone'),
            const SizedBox(height: 20),
            _buildTextField(context, 'Password', isPass: true),
            const SizedBox(height: 25),

            // Tombol Lupa Password aktif klik
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  'Lupa password?',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: kPrimaryColor, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 35),

            InkWell(
              onTap: () {
                // TODO: Tambahkan aksi logika login pemilik jika backend ready
              },
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Belum punya akun? ",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey, fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPemilikScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Daftar",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label,
      {bool isPass = false}) {
    return buildGlassContainer(
      radius: 12,
      child: TextField(
        obscureText: isPass,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}
