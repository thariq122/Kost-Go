import 'package:flutter/material.dart';

// Centralized UI constants and helpers for screens (visual-only changes)
const Color kPrimaryColor = Color(0xff14b8a6);
const Color kAccentColor = Color(0xff9333ea);
const Color kScaffoldBg = Color(0xff121212);
const Color kAppBarBg = Color(0xff1e1e1e);
const Color kCardBg = Color(0xff1e1e1e);

BoxDecoration kCardDecoration({double radius = 12}) {
  return BoxDecoration(
    color: kCardBg,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.35),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

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
            ?.copyWith(color: Colors.white)),
    actions: actions,
  );
}

Widget imagePlaceholder({double size = 40}) {
  return Icon(Icons.image_outlined, color: Colors.white24, size: size);
}
