import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inri_driver/constants/constants.dart';
import 'package:inri_driver/pages/register_login/login/login_page.dart';
import 'package:inri_driver/service/socket_service.dart';
import 'package:inri_driver/service/storage_service.dart';
import 'package:inri_driver/utils/viaje_utils.dart';


class AppBarConstants {
  AppBarConstants._();

  static final ValueNotifier<bool> isOnline = ValueNotifier<bool>(false);
  final token =  StorageService.instance.getTokenUser();


  static AppBar customAppBar(BuildContext context, String nombre) {
    final screenHeight = MediaQuery.of(context).size.height;
    String textoOriginal = nombre;
    String name = textoOriginal.length > 7
        ? '${textoOriginal.substring(0, 7)}...'
        : textoOriginal;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola,',
                style: GoogleFonts.lobsterTwo(
                  fontSize: screenHeight <= 640 ? 18 : 23,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.secondColor,
                  shadows: const [
                    Shadow(
                      color: Color.fromRGBO(218, 145, 252, 0.843),
                      blurRadius: 20.0,
                    )
                  ],
                  letterSpacing: 1.7,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: screenHeight <= 640 ? 18 : 20,
                  fontWeight: FontWeight.w700,
                  color: AppConstants.secondColor,
                  shadows: const [
                    Shadow(
                      color: Color.fromRGBO(218, 145, 252, 0.843),
                      blurRadius: 20.0,
                    )
                  ],
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: isOnline,
          builder: (context, value, _) {
            return Row(
              children: [
                Text(
                  'Online',
                  style: TextStyle(
                    color: value ? const Color.fromARGB(255, 6, 242, 128) : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: value,
                  activeColor: const Color.fromARGB(255, 1, 208, 108),
                  onChanged: (val) async {
                    isOnline.value = val;
                    if (val) {
                      // 🔐 Leer token del storage y conectar socket
                      final token = await StorageService.instance.getTokenUser();
                      if (token != null) {
                      
                        SocketService.instance.initSocket(token: token);
                      }
                    } else {
                      SocketService.instance.finishSocket();
                    }
                  },
                ),
              ],
            );
          },
        ),
        IconButton(
          onPressed: () {},
          icon: CircleAvatar(
            backgroundColor: AppConstants.containerColors,
            child: const Icon(
              Icons.person,
              size: 26,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            if (!context.mounted) return;
            await ViajeUtils.finishTravelandClearAll(context);
            if (!context.mounted) return;
            Future.delayed(const Duration(milliseconds: 200));
            Navigator.pushAndRemoveUntil(
              context,
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
          },
          icon: Icon(
            Icons.exit_to_app,
            size: 26,
            color: AppConstants.secondColor,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

