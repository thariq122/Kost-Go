import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/favorites_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/ui_helpers.dart';

void main() {
  runApp(
    // 3. Bungkus MyApp dengan MultiProvider agar state-nya bisa diakses global
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
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
      title: 'KostGo Bro',
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
