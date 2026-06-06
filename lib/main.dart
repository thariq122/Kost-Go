import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/kost_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/owner_stats_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/ui_helpers.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => KostProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => OwnerStatsProvider()),
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
      home: const _AppInit(),
    );
  }
}

/// Restore session sebelum menampilkan SplashScreen
class _AppInit extends StatefulWidget {
  const _AppInit();
  @override
  State<_AppInit> createState() => _AppInitState();
}

class _AppInitState extends State<_AppInit> {
  @override
  void initState() {
    super.initState();
    // Restore session dari SharedPreferences
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().restoreSession();
    });
  }

  @override
  Widget build(BuildContext context) => const SplashScreen();
}
