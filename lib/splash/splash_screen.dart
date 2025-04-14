import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inri_driver/animation/animate_page.dart';
import 'package:inri_driver/pages/register_login/login/login_page.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double boxX = 0;
  double boxY = -2;

  void _moveBox() {
    setState(() {
      boxX = 0;
      boxY = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Animar el logo hacia el centro
    Future.delayed(const Duration(seconds: 1), _moveBox);

    // Navegar al login después de unos segundos
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return; 
      Navigator.of(context).push(
        AnimatePage(child: const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(250, 63, 2, 230),
              Color.fromARGB(251, 61, 3, 223),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(seconds: 2),
          curve: Curves.bounceOut,
          alignment: Alignment(boxX, boxY),
          child: const SizedBox(
            width: 350,
            height: 350,
            child: Image(
              image: AssetImage('assets/logo.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}