import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inri_driver/animation/animate_page.dart';
import 'package:inri_driver/constants/constants.dart';
import 'package:inri_driver/pages/privacy_page.dart';
import 'package:inri_driver/widgets/forms/inputs.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  gradient: AppConstants.backgroundCard
                  ),
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
                      ], begin: Alignment.topCenter, end: Alignment.center)
                      ), 
                      ),
                  ),
          
                  Positioned(
                    top: height * 0.08,
                    left: 05.0,
                    right: 05.0,
                    child: const FormImputs()
                  ),
          
                  Positioned(
                    top: height * 0.23,
                    left: 10.0,
                    right: 10.0,
                    child: Container(
                       
                     width: 250,
                     height: 220,         
                     decoration: const BoxDecoration(                                    
                     image: DecorationImage(
                     image: AssetImage('assets/car_b.png'),                
                  ),
                  
                  ),
                    ),
                  )
          
          
                ],
              )
             
              ),
        ),
      ),
    );
    //);
  }
}

class FormImputs extends StatefulWidget {
  
  const FormImputs({super.key});

  @override
  State<FormImputs> createState() => _FormImputsState();
}

class _FormImputsState extends State<FormImputs> {

  @override
  Widget build(BuildContext context) {
  

  final heigthScreen = MediaQuery.of(context).size.height;

  return SingleChildScrollView(
    child: Container(
      height: 700,
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
      child: Text('Bienvenido, a Inri Conductor',
          style: GoogleFonts.roboto(
              fontSize: 18,
              color: AppConstants.textColor,
              fontWeight: FontWeight.bold)),
    ),
    SizedBox(height: heigthScreen *0.30),
    
    const ImputsUserLogin(),   
    
    const SizedBox(height: 25),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿Aun no Tienes Cuenta?',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 221, 203, 252)),
        ),
        const SizedBox(width: 10),
        TextButton(
            onPressed: () {
              
                 Navigator.of(context).push(     
              AnimatePage(child: const PrivacyPage())    
              );   
              
            },
            child: Text(
              'Registrate Aqui',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: AppConstants.yellow),
            ))
      ],
    )
  ],
      ),
    ),
  );
}

}
