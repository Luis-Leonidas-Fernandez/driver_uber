import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inri_driver/controllers/controllers_keys.dart';
import 'package:inri_driver/controllers/register_user_controllers.dart';
import 'package:inri_driver/styles/containers_decorations.dart';
import 'package:inri_driver/styles/text_field_decorations.dart';
import 'package:inri_driver/utils/responsive_utils.dart';
import 'package:inri_driver/validators/input_field_validator.dart';

// Configuración para cada input
class InputFieldConfig {
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final String hintText;
  final double maxWidth;
  final List<String? Function(String?)> validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;


  InputFieldConfig({
    required this.icon,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    required this.hintText,
    required this.maxWidth,
    required this.validator,
    required this.keyboardType,
    this.inputFormatters
  });
}



class FormStepOne extends StatefulWidget {
  final RegisterUserController registerUserController;
  final GlobalKey<FormState> formKey;

  const FormStepOne({
    super.key,
    required this.registerUserController,
    required this.formKey
  });

  @override
  State<FormStepOne> createState() => _FormStepOneState();
}

class _FormStepOneState extends State<FormStepOne> {
  // Definimos todos los FocusNode
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode nombreFocusNode = FocusNode();
  final FocusNode apellidoFocusNode = FocusNode();
 
 

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nombreFocusNode.dispose();
    apellidoFocusNode.dispose();

    super.dispose();
  }

  // Genera la lista de campos dinámicamente con tamaño correcto
  List<dynamic> _crearCampos(double screenWidth) {

  


    return [
      InputFieldConfig(
        icon: Icons.email,
        controller: widget.registerUserController.controllers[ControllerKeys.email]!,
        focusNode: emailFocusNode,
        nextFocusNode: passwordFocusNode,
        hintText: 'email',
        maxWidth: getMaxWidth(screenWidth, 0.7),
        keyboardType: TextInputType.text,
        validator: [
         InputFieldValidator.required,
         InputFieldValidator.email  // Se asegura que solo contenga letras
       ],
      ),
      InputFieldConfig(
        icon: Icons.key,
        controller: widget.registerUserController.controllers[ControllerKeys.password]!,
        focusNode: passwordFocusNode,
        nextFocusNode: nombreFocusNode,
        hintText: 'Contrasena',
        maxWidth: getMaxWidth(screenWidth, 0.3),
        keyboardType: TextInputType.text,        
        validator: [
          InputFieldValidator.required,
          //InputFieldValidator.numeric
        ],
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ]
      ),
           
      InputFieldConfig(
        icon: Icons.person,
        controller: widget.registerUserController.controllers[ControllerKeys.nombre]!,
        focusNode: nombreFocusNode,
        nextFocusNode: apellidoFocusNode,
        hintText: 'Nombre',
        maxWidth: getMaxWidth(screenWidth, 0.15),
        keyboardType: TextInputType.text,
        validator: [
          InputFieldValidator.required,
          
        ],
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')) // letras y espacios

        ]
        
      ),
      InputFieldConfig(
        icon: Icons.perm_identity,
        controller: widget.registerUserController.controllers[ControllerKeys.apellido]!,
        focusNode: apellidoFocusNode,
        nextFocusNode: null,
        hintText: 'Apellido',
        maxWidth: getMaxWidth(screenWidth, 0.15),
        keyboardType: TextInputType.text,
        validator: [
          InputFieldValidator.required,
          
        ],
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')) // letras y espacios

        ]
      ),
      
      
    ];


  }

  @override
  Widget build(BuildContext context) {
    
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    

    final fields = _crearCampos(screenWidth);

    return Form(
      key: widget.formKey,
      child: Column(
        children: [


           Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildInputContainer(fields[0], screenWidth, isFullWidth: true),
            ),
          SizedBox(height: screenHeight <= 641 ? 4 : 3),
          Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildInputContainer(fields[1], screenWidth, isFullWidth: true),
            ),  

           SizedBox(height: screenHeight <= 641 ? 4 : 3),

           Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildInputContainer(fields[2], screenWidth, isFullWidth: true),
            ),  

          SizedBox(height: screenHeight <= 641 ? 4 : 3),

          Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildInputContainer(fields[3], screenWidth, isFullWidth: true),
            ), 
   

         
          const SizedBox(height: 10), 
        ],
      ),
    );
  }

  Widget _buildInputContainer(dynamic config, double screenHeight, {bool isFullWidth = false}) {
  return Container(
    width: calcularAnchoDisponible(
      context: context,
      baseWidth: config.maxWidth,
      iconWidth: 40.0,
      paddingHorizontal: 6.8,
      isFullWidth: isFullWidth,   // Aquí le indicas si es full-width
    ),
    height: screenHeight <= 640 ? 50 : 55,
    decoration: ContainerStyles.containerDecoration(),
    child: _buildContentRow(config, screenHeight),
  );
}

  Widget _buildContentRow(dynamic config, double screenHeight) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 30, minHeight: 33),
            decoration: ContainerStyles.containerIconDecoration(),
            child: Icon(config.icon, color: Colors.white,
            size: screenHeight <= 380 ? 18 : 25),
          ),
        ),
        Expanded(
        child: _buildTextFormField(config, screenHeight), // 🔹 Si no, usa TextField
      ),
      ],
    );
  }

  TextFormField _buildTextFormField(InputFieldConfig config, double screenHeight) {
  return TextFormField(
    focusNode: config.focusNode,
    controller: config.controller,
    cursorColor: Colors.white,
    autocorrect: false,
    keyboardType: config.keyboardType,
    style: TextFieldStyles.textFieldTextStyle(),
    decoration: TextFieldStyles.inputDecoration(screenHeight, config.hintText),
    validator: (value) {
      for (final validator in config.validator) {
        final result = validator(value);
        if (result != null) return result;  // Si un validador falla, retorna el mensaje
      }
      return null; // Si ninguna validación falla, es válido
    },
    onChanged: (value) {

    },
    onFieldSubmitted: (_) {
      if (config.nextFocusNode != null) {
        FocusScope.of(context).requestFocus(config.nextFocusNode);
      } else {
        FocusScope.of(context).unfocus();
      }
    },
  );
}

}