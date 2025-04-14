import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:inri_driver/pages/register_login/login/login_page.dart';

void navigateToLogin(BuildContext context) {
  SchedulerBinding.instance.addPostFrameCallback((_) async {
    
    await Future.delayed(const Duration(milliseconds: 500));
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          final slide = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation);
          final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
          return SlideTransition(
            position: slide,
            child: FadeTransition(
              opacity: fade,
              child: child,
            ),
          );
        },
      ),
      (_) => false,
    );
  });
}
