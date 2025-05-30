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


class FormStepTwo extends StatefulWidget {
  final RegisterUserController registerUserController;
  final GlobalKey<FormState> formKey;

  const FormStepTwo({
    super.key,
    required this.registerUserController,
    required this.formKey
  });

  @override
  State<FormStepTwo> createState() => _FormStepTwoState();
}

class _FormStepTwoState extends State<FormStepTwo> {
  // Definimos todos los FocusNode
  final FocusNode nacimientoFocusNode = FocusNode();
  final FocusNode domicilioFocusNode = FocusNode();
  final FocusNode vehiculoFocusNode = FocusNode();
  final FocusNode modeloFocusNode = FocusNode();
 
 

  @override
  void dispose() {
    nacimientoFocusNode.dispose();
    domicilioFocusNode.dispose();
    vehiculoFocusNode.dispose();
    modeloFocusNode.dispose();

    super.dispose();
  }

  // Genera la lista de campos dinámicamente con tamaño correcto
  List<dynamic> _crearCampos(double screenWidth) {

  


    return [
      InputFieldConfig(
        icon: Icons.timelapse,
        controller: widget.registerUserController.controllers[ControllerKeys.fechaNacimiento]!,
        focusNode: nacimientoFocusNode,
        nextFocusNode: domicilioFocusNode,
        hintText: 'fecha nacimiento',
        maxWidth: getMaxWidth(screenWidth, 0.7),
        keyboardType: TextInputType.none,
        validator: [
         InputFieldValidator.required,
         InputFieldValidator.date,  // Se asegura que solo contenga letras
       ],
      ),
      InputFieldConfig(
        icon: Icons.key,
        controller: widget.registerUserController.controllers[ControllerKeys.domicilio]!,
        focusNode: domicilioFocusNode,
        nextFocusNode: vehiculoFocusNode,
        hintText: 'domicilio',
        maxWidth: getMaxWidth(screenWidth, 0.3),
        keyboardType: TextInputType.text,        
        validator: [
          InputFieldValidator.required,          
        ],
        
      ),
           
      InputFieldConfig(
        icon: Icons.car_crash,
        controller: widget.registerUserController.controllers[ControllerKeys.vehiculo]!,
        focusNode: vehiculoFocusNode,
        nextFocusNode: modeloFocusNode,
        hintText: 'Marca de vehiculo',
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
        icon: Icons.car_crash_rounded,
        controller: widget.registerUserController.controllers[ControllerKeys.modelo]!,
        focusNode: modeloFocusNode,
        nextFocusNode: null,
        hintText: 'Modelo del vehiculo',
        maxWidth: getMaxWidth(screenWidth, 0.15),
        keyboardType: TextInputType.text,
        validator: [
          InputFieldValidator.required,
          
        ],
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
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
            ), // Tipo de carga
      
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
          SizedBox(height: screenHeight <= 641 ? 6 : 10),

          
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
            height: 36,
            width: 38,
            //constraints: const BoxConstraints(maxWidth: 30, minHeight: 33),
            decoration: ContainerStyles.containerIconDecoration(),
            child: Icon(config.icon, color: Colors.white,
            size: screenHeight <= 380 ? 18 : 30),
          ),
        ),
        Expanded(
        child:  _buildTextFormField(config, screenHeight), // 🔹 Si no, usa TextField
      ),
      ],
    );
  }

  TextFormField _buildTextFormField(InputFieldConfig config, double screenHeight) {
  return TextFormField(
    focusNode: config.focusNode,
    controller: config.controller,
    readOnly: config.keyboardType == TextInputType.none,
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
    onTap: config.keyboardType == TextInputType.none ? () async {
      final pickedDate = await showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(1950),
  lastDate: DateTime(2100),
  builder: (context, child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          onPrimary: Colors.white,
          surface: Color(0xFF1E1E1E),
          onSurface: Colors.white,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: Color(0xFF1A1A1A),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 251, 250, 252),
          ),
        ),
      ),
      child: child!,
    );
  },
);


      if (!context.mounted) return;

       if (pickedDate != null) {
         final formattedDate = '${pickedDate.day.toString().padLeft(2, '0')}/'
             '${pickedDate.month.toString().padLeft(2, '0')}/'
             '${pickedDate.year}';


        setState(() {
          // ✅ Actualiza el controlador del campo de texto
         config.controller.text = formattedDate;
         // ✅ Guarda la fecha en el `CargaController`
         widget.registerUserController.controllers[ControllerKeys.fechaNacimiento]?.text = formattedDate;
        
        });    
        
         // ✅ Valida el formulario
         final formKeys = widget.formKey;
         if (formKeys.currentState?.mounted ?? false) {
           formKeys.currentState?.validate();
         }
       } else {
         return;         
       }
    } : null,
    onChanged: (value) {
           
       // 🔹 Reemplazar `,` con `.` automáticamente en propiedad peso
         final newValue = value.replaceAll(',', '.');
         if (newValue != value) {
           config.controller.text = newValue;
         }

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