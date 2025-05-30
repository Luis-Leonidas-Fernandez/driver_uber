import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inri_driver/blocs/user/auth_bloc.dart';
import 'package:inri_driver/constants/constants.dart';
import 'package:inri_driver/pages/register_login/register/widgets/steeper_register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late AuthBloc _authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = context.read<AuthBloc>(); // Guardás una referencia segura
  }

  @override
  void dispose() {
    _authBloc.registerUserController.dispose(); // Ahora sí, sin errores
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // Oculta el teclado al tocar cualquier lugar fuera de los inputs
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              constraints: const BoxConstraints(maxHeight: 950),
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/background_image.webp'),
                      fit: BoxFit.cover,
                      opacity: 0.9),
                  gradient: AppConstants.backgroundCard),
              child: Stack(
                children: [
                  Positioned(
                    top: height * 0.6,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      width: double.infinity,
                      height: 600,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        AppConstants.cardColor.withAlpha(2),
                        AppConstants.cardColor,
                      ], begin: Alignment.topCenter, end: Alignment.center)),
                    ),
                  ),
                  Positioned(
                      top: height < 650 ? 0.02 : 28,
                      left: 05.0,
                      right: 05.0,
                      child: const FormRegister()),
                  Positioned(
                    top: height * 0.18,
                    left: 10.0,
                    right: 10.0,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/car_b.png'),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  @override
  Widget build(BuildContext context) {
    final heigthScreen = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Center(
      child: SingleChildScrollView(
        child: Container(
          height: 1250,
          color: Colors.transparent,
          child: Column(
            children: [
              Text('¡Hola de Nuevo!',
                  style: GoogleFonts.lobsterTwo(
                      fontSize: 48,
                      color: AppConstants.textColor,
                      shadows: <Shadow>[
                        const Shadow(color: Colors.black87, blurRadius: 20.0)
                      ])),
              const SizedBox(height: 10),
              ShaderMask(
                shaderCallback: (bounds) {
                  return const RadialGradient(
                      center: Alignment.topRight,
                      radius: 4.0,
                      colors: [
                        Color.fromARGB(255, 99, 47, 241),
                        Color.fromARGB(255, 42, 138, 248),
                      ]).createShader(bounds);
                },
                child: Text('Bienvenido, a Inri Conductores',
                    style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: AppConstants.textColor,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: heigthScreen * 0.21),

              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state.usuario != null) {
                
                  // El usuario ya fue registrado con éxito y está en el estado
                 
                  
                  Navigator.pushReplacementNamed(context, 'loading');
                   }
                  
                },
                child: const BuildSteeperFormRegistration(),
              ),
              SizedBox(height: heigthScreen < 365 ? 1 : 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿Tienes Cuenta?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 221, 203, 252)),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                      onPressed: () {
                        if (context.mounted) {
                         
                              Navigator.pushReplacementNamed(context, 'login');
                        }
                      },
                      child: Text(
                        'Inicia sesion aquí',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppConstants.yellow),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
