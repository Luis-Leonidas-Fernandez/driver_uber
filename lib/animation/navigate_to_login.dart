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
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      (_) => false,
    );
  });
}
