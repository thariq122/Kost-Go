import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ==================== COLORS ====================
const Color kPrimaryColor = Color(0xff14b8a6);
const Color kPrimaryDark = Color(0xff0d9488);
const Color kPrimaryLight = Color(0xff2dd4bf);

const Color kAccentColor = Color(0xff9333ea);
const Color kAccentDark = Color(0xff7c3aed);
const Color kAccentLight = Color(0xffa855f7);

const Color kScaffoldBg = Color(0xff0a0a0a); // Slightly darker for premium feel
const Color kAppBarBg = Color(0xff121212); // slightly lighter than scaffold
const Color kCardBg = Color(0xff18181b); // Zinc 900 for modern dark cards

// ==================== GRADIENTS ====================
const LinearGradient kPrimaryGradient = LinearGradient(
  colors: [kPrimaryDark, kPrimaryLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient kAccentGradient = LinearGradient(
  colors: [kAccentDark, kAccentLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient kCardGradient = LinearGradient(
  colors: [Color(0xff1e1e1e), Color(0xff18181b)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ==================== TEXT STYLES ====================
TextTheme get kTextTheme => GoogleFonts.plusJakartaSansTextTheme().apply(
  bodyColor: Colors.white,
  displayColor: Colors.white,
);

// ==================== DECORATIONS ====================
BoxDecoration kCardDecoration({double radius = 16}) {
  return BoxDecoration(
    color: kCardBg,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.4),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

// Elevated card decoration with gradient border
BoxDecoration kElevatedCardDecoration({double radius = 16}) {
  return BoxDecoration(
    gradient: kCardGradient,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: kPrimaryColor.withValues(alpha: 0.2)),
    boxShadow: [
      BoxShadow(
        color: kPrimaryColor.withValues(alpha: 0.15),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );
}

// Glassmorphism helper
BoxDecoration kGlassDecoration({double radius = 16}) {
  return BoxDecoration(
    color: Colors.white.withValues(alpha: 0.05),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 10,
      )
    ],
  );
}

Widget buildGlassContainer({
  required Widget child,
  double radius = 16,
  EdgeInsets padding = EdgeInsets.zero,
  double? width,
  double? height,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: kGlassDecoration(radius: radius),
        child: child,
      ),
    ),
  );
}

// ==================== BUILDERS ====================
AppBar buildAppBar(BuildContext context, String title,
    {bool showBack = true, List<Widget>? actions}) {
  return AppBar(
    backgroundColor: kAppBarBg,
    elevation: 0,
    leading: showBack
        ? IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          )
        : null,
    title: Text(title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
    actions: actions,
  );
}

Widget imagePlaceholder({double size = 40}) {
  return Icon(Icons.image_outlined, color: Colors.white24, size: size);
}

Widget buildAnimatedBadge(String text, {Color? color}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          (color ?? kPrimaryColor).withValues(alpha: 0.2),
          (color ?? kPrimaryColor).withValues(alpha: 0.1),
        ],
      ),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: (color ?? kPrimaryColor).withValues(alpha: 0.3)),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: color ?? kPrimaryColor,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
