import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // 2. UBAH VARIABEL TEMPORER MENJADI BYTES
  Uint8List? _webImageBytes;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    _nameController = TextEditingController(text: authProvider.userName);
    _emailController = TextEditingController(text: authProvider.userEmail);
    _phoneController = TextEditingController(text: authProvider.userPhone);
    // Ambil bytes foto lama jika ada
    _webImageBytes = authProvider.profileImageBytes;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // 3. UPDATE FUNGSI PICK IMAGE UTK BACA BYTES
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Di web, camera source biasanya diabaikan dan langsung buka file picker
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      // BACA GAMBAR SEBAGAI BYTES (Ini jalan di Web & HP)
      var f = await image.readAsBytes();
      setState(() {
        _webImageBytes = f; // Set bytes gambar sementara di UI
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      Provider.of<AuthProvider>(context, listen: false).updateProfile(
        _nameController.text,
        _emailController.text,
        _phoneController.text,
      );

      // 4. SIMPAN DATA BYTES KE PROVIDER
      Provider.of<AuthProvider>(context, listen: false)
          .updateProfilePicture(_webImageBytes);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: kAppBarBg,
        elevation: 0,
        title: Text('Edit Profil',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SEKSI FOTO PROFIL DINAMIS UTK WEB ---
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: kCardBg,
                      // GUNAKAN MEMORYIMAGE UTK MENAMPILKAN BYTES
                      backgroundImage: _webImageBytes != null
                          ? MemoryImage(_webImageBytes!)
                          : null,
                      child: _webImageBytes == null
                          ? const Icon(Icons.person,
                              size: 50, color: Colors.tealAccent)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: kPrimaryColor,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.camera_alt,
                              size: 16, color: Colors.white),
                          // Di web, fungsi picker pilihan dihapus, langsung panggil _pickImage
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              _buildInputField(context, 'Nama Lengkap', _nameController,
                  Icons.person_outline),
              const SizedBox(height: 16),
              _buildInputField(
                  context, 'Email', _emailController, Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildInputField(context, 'Nomor WhatsApp', _phoneController,
                  Icons.phone_outlined,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _saveProfile,
                  child: Text('Simpan Perubahan',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String label,
      TextEditingController controller, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: kCardBg,
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xff14b8a6), width: 1)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }
}
