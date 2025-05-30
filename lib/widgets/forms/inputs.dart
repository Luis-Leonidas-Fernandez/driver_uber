import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_driver/blocs/user/auth_bloc.dart';
import 'package:inri_driver/styles/containers_decorations.dart';
import 'package:inri_driver/styles/text_field_decorations.dart';
import 'package:inri_driver/utils/responsive_utils.dart';
import 'package:inri_driver/validators/input_field_validator.dart';
import 'package:inri_driver/widgets/dialogs/alert_screen.dart';
import 'package:inri_driver/widgets/buttons/btn_reusable.dart';



class InputFieldConfig {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final TextInputType inputType;
  final double maxWidth;
  final List<String? Function(String?)> validator;

  InputFieldConfig({
    required this.icon,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    required this.inputType,
    required this.validator,
    required this.maxWidth
  });
}

class ImputsUserLogin extends StatefulWidget {
  const ImputsUserLogin({super.key});

  @override
  State<ImputsUserLogin> createState() => _ImputsUserLoginState();
}

class _ImputsUserLoginState extends State<ImputsUserLogin> {
  
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final emailFocusNode = FocusNode();
  final passFocusNode = FocusNode();
  
  
  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    emailFocusNode.dispose();
    passFocusNode.dispose();
    super.dispose();
  }

  List<InputFieldConfig> _crearContainers(double screenWidth) {
  return [
          InputFieldConfig(
        icon: Icons.email,
        hintText: 'maria@gmail.com',
        controller: emailCtrl,
        focusNode: emailFocusNode,
        nextFocusNode: passFocusNode,
        inputType: TextInputType.emailAddress,
        maxWidth: getMaxWidth(screenWidth, 0.7),
        validator: [
          InputFieldValidator.required, 
          InputFieldValidator.email
        ],
      ),
      InputFieldConfig(
        icon: Icons.lock_outline,
        hintText: 'Contraseña',
        controller: passCtrl,
        focusNode: passFocusNode,
        nextFocusNode: null,
        inputType: TextInputType.text,
        maxWidth: getMaxWidth(screenWidth, 0.7),
        validator: [
          InputFieldValidator.required,
          InputFieldValidator.password
        ]
      )
    ];    
  }
  

  @override
  Widget build(BuildContext context) {

    final authUser = BlocProvider.of<AuthBloc>(context);
   
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final fields = _crearContainers(screenWidth);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildInputField(fields[0], screenWidth, isFullWidth: true),
            ),
          SizedBox(height: screenHeight <= 641 ? 4 : 3),
          Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildInputField(fields[1], screenWidth, isFullWidth: true),
            ),  
          const SizedBox(height: 20),
          ButtonReusable(
            text: 'Ingresar',
            onPressed: authUser.state.usuario != null
                ? () {}
                : () async {
                    if (!_formKey.currentState!.validate()) {
                      return; // Si algún campo falla, no sigue
                    }

                    final loginOk = await authUser.initLogin(
                      emailCtrl.text.trim(),
                      passCtrl.text.trim(),
                    );

                    if (!context.mounted) return;

                    if (loginOk) {
                      
                      Navigator.pushReplacementNamed(
                      context, 'loading');
                    } else {
                      mostrarAlerta(
                        context,
                        'Login incorrecto',
                        'Revise sus credenciales nuevamente',
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(InputFieldConfig field, double screenHeight, {bool isFullWidth = false}) {
    
    return Container(      
      width: calcularAnchoDisponible(
      context: context,
      baseWidth: field.maxWidth,
      iconWidth: 40.0,
      paddingHorizontal: 6.8,
      isFullWidth: isFullWidth,   // Aquí le indicas si es full-width
    ),
    height: screenHeight <= 640 ? 55 : 50,     
      decoration: ContainerStyles.containerDecoration(),
      child: Row(
        children: [
          _buildIconContainer(field.icon, screenHeight),
          Expanded(child: _buildTextFormField(field, screenHeight)),
        ],
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Container(
        width: 38,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(188, 126, 124, 250).withValues(),
              const Color.fromARGB(188, 126, 124, 250),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: screenHeight <= 380 ? 18 : 30),
      ),
    );
  }

  Widget _buildTextFormField(InputFieldConfig field, double screenHeight) {
    return TextFormField(
      controller: field.controller,
      focusNode: field.focusNode,
      cursorColor: Colors.white,
      autocorrect: false,
      keyboardType: field.inputType,
      obscureText: field.hintText.toLowerCase().contains('contraseña'),
      style: TextFieldStyles.textFieldTextStyle(),
      decoration: TextFieldStyles.inputDecoration(screenHeight, field.hintText),
      validator: (value) {
      for (final validator in field.validator) {
       final result = validator(value);
       if (result != null) return result;  // Si un validador falla, retorna el mensaje
       }
         return null; // Si ninguna validación falla, es válido
      },
      onFieldSubmitted: (_) {
        if (field.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(field.nextFocusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}
