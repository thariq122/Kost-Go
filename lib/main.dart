import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- 1. Import package provider
import 'providers/auth_provider.dart'; // <-- 2. Import AuthProvider yang kita buat tadi
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/ui_helpers.dart';

void main() {
  runApp(
    // 3. Bungkus MyApp dengan MultiProvider agar state-nya bisa diakses global
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Kalau besok-besok mau nambah kost_provider atau booking_provider, tinggal taruh di bawah sini, Bang
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
      debugShowCheckedModeBanner: false,
      title: 'KostGo',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: kTextTheme,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kScaffoldBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: kAppBarBg,
          elevation: 0,
          centerTitle: true,
        ),
        colorScheme: const ColorScheme.dark(
          primary: kPrimaryColor,
          secondary: kAccentColor,
          surface: kCardBg,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
