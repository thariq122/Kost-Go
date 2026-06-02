import 'dart:async';
import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'ui_helpers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _logoFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _textFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.9, curve: Curves.easeIn),
    );

    _textSlideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainNavigation(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff050505), // Sangat gelap
              Color(0xff0d2524), // Hint teal
              Color(0xff050505),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Particle effect simulation with simple blurred circles
            Positioned(
              top: -50,
              left: -50,
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) => Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor.withValues(
                          alpha: 0.1 * _glowAnimation.value),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withValues(
                              alpha: 0.2 * _glowAnimation.value),
                          blurRadius: 100,
                          spreadRadius: 50,
                        )
                      ]),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -50,
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) => Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kAccentColor.withValues(
                          alpha: 0.1 * _glowAnimation.value),
                      boxShadow: [
                        BoxShadow(
                          color: kAccentColor.withValues(
                              alpha: 0.15 * _glowAnimation.value),
                          blurRadius: 120,
                          spreadRadius: 60,
                        )
                      ]),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bagian Logo
                  FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: Image.asset(
                        'assets/images/LogoKostGo.png',
                        width: 160,
                        height: 160,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.maps_home_work_rounded,
                          color: Colors.white,
                          size: 160,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Bagian Teks & Tagline
                  AnimatedBuilder(
                    animation: _textSlideAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textSlideAnimation.value),
                        child: FadeTransition(
                          opacity: _textFadeAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'KostGo',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                kPrimaryColor.withValues(alpha: 0.2),
                                kPrimaryColor.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: kPrimaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            '#EnaknyaNgekos',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: kPrimaryLight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bagian Keterangan Bawah
            Positioned(
              bottom: 50,
              left: 40,
              right: 40,
              child: FadeTransition(
                opacity: _textFadeAnimation,
                child: Column(
                  children: [
                    SizedBox(
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          minHeight: 4,
                          backgroundColor: Colors.white10,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(kPrimaryLight),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aplikasi Pencarian Kost Terbaik di Indonesia',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
