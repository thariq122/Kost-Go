import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/kost_provider.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  runApp(
    // Mendaftarkan semua provider agar bisa diakses di seluruh halaman aplikasi
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => KostProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KostGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark, // Mengikuti tema gelap di referensi kamu
        ),
      ),
      // Halaman pertama yang dibuka adalah Login Screen
      home: const LoginScreen(),
    );
  }
}
