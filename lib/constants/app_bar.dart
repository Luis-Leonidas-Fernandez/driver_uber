import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:inri_driver/blocs/base/base_bloc.dart';
import 'package:inri_driver/blocs/user/auth_bloc.dart';
import 'package:inri_driver/constants/constants.dart';
import 'package:inri_driver/pages/register_login/login/login_page.dart';
import 'package:inri_driver/service/storage_service.dart';
import 'package:inri_driver/utils/viaje_utils.dart';

class AppBarConstants {
  AppBarConstants._();

  static AppBar customAppBar(BuildContext context) {
    const nombre = 'Marco';
    final screenHeight = MediaQuery.of(context).size.height;
    final storage = StorageService.instance;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: SafeArea(
        // ✅ para evitar superposición con la barra de estado
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0), // 🔝 espacio extra opcional
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
                nombre,
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
            await storage.deleteIdOrder();
            if (!context.mounted) return;
            await ViajeUtils.finishTravelandClearAll(context);
            if (!context.mounted) return;

            context.read<BaseBloc>().add(ClearBaseEvent()); // 🔥 limpia BaseBloc
            context.read<AuthBloc>().add(const OnClearUserSessionEvent());

            await HydratedBloc.storage.clear();
            if (!context.mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
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
