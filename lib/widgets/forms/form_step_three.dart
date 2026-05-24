import 'dart:io';
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

  InputFieldConfig(
      {required this.icon,
      required this.controller,
      required this.focusNode,
      this.nextFocusNode,
      required this.hintText,
      required this.maxWidth,
      required this.validator,
      required this.keyboardType,
      this.inputFormatters});
}

class FormStepThree extends StatefulWidget {
  final RegisterUserController registerUserController;
  final GlobalKey<FormState> formKey;

  const FormStepThree(
      {super.key, required this.registerUserController, required this.formKey});

  @override
  State<FormStepThree> createState() => _FormStepThreeState();
}

class _FormStepThreeState extends State<FormStepThree> {
  // Definimos todos los FocusNode
  final FocusNode patenteFocusNode = FocusNode();
  final FocusNode licenciaFocusNode = FocusNode();


  @override
  void dispose() {
    patenteFocusNode.dispose();
    licenciaFocusNode.dispose();
    super.dispose();
  }

  // Genera la lista de campos dinámicamente con tamaño correcto
  List<dynamic> _crearCampos(double screenWidth) {
    return [
      InputFieldConfig(
        icon: Icons.credit_card,
        controller:
            widget.registerUserController.controllers[ControllerKeys.patente]!,
        focusNode: patenteFocusNode,
        nextFocusNode: licenciaFocusNode,
        hintText: 'patente',
        maxWidth: getMaxWidth(screenWidth, 0.7),
        keyboardType: TextInputType.text,
        validator: [
          InputFieldValidator.required,
        ],
      ),
      InputFieldConfig(
          icon: Icons.assignment,
          controller: widget
              .registerUserController.controllers[ControllerKeys.licencia]!,
          focusNode: licenciaFocusNode,
          nextFocusNode: null,
          hintText: 'Licencia',
          maxWidth: getMaxWidth(screenWidth, 0.3),
          keyboardType: TextInputType.text,
          validator: [
            InputFieldValidator.required,
          ],
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
          ]),
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
            child:
                _buildInputContainer(fields[0], screenWidth, isFullWidth: true),
          ),

          SizedBox(height: screenHeight <= 641 ? 6 : 4),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child:
                _buildInputContainer(fields[1], screenWidth, isFullWidth: true),
          ),

          SizedBox(height: screenHeight <= 641 ? 6 : 4),

          // 👇 NUEVOS INPUTS DE FOTO FRENTE Y DORSO
          buildImagePickerInput(
            context: context,
            icon: Icons.photo_camera_front,
            label: 'Foto Carnet Frente',
            fileName: 'Foto Carnet Frente',
            imagePath: widget.registerUserController
                    .controllers[ControllerKeys.fotoFrente]?.text ??
                '',
            onTap: () async {
              await widget.registerUserController.pickImage(
                isFrente: true,
                onChanged: () => setState(() {}),
              );
            },
            screenHeight: MediaQuery.of(context).size.height,
            maxWidth: calcularAnchoDisponible(
              context: context,
              baseWidth: MediaQuery.of(context).size.width,
              iconWidth: 40.0,
              paddingHorizontal: 8.0,
              //isFullWidth: isFullWidth,
            ),
          ),
          SizedBox(height: screenHeight <= 641 ? 6 : 12),
          buildImagePickerInput(
            context: context,
            icon: Icons.photo_camera_front,
            label: 'Foto Carnet Dorso',
            fileName: 'Foto Carnet Dorso',
            imagePath: widget.registerUserController
                    .controllers[ControllerKeys.fotoDorso]?.text ??
                '',
            onTap: () async {
              await widget.registerUserController.pickImage(
                isFrente: false,
                onChanged: () => setState(() {}),
              );
            },
            screenHeight: MediaQuery.of(context).size.height,
            maxWidth: calcularAnchoDisponible(
              context: context,
              baseWidth: MediaQuery.of(context).size.width,
              iconWidth: 40.0,
              paddingHorizontal: 8.0,
              //isFullWidth: isFullWidth,
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInputContainer(dynamic config, double screenHeight,
      {bool isFullWidth = false}) {
    return Container(
      width: calcularAnchoDisponible(
        context: context,
        baseWidth: config.maxWidth,
        iconWidth: 40.0,
        paddingHorizontal: 6.8,
        isFullWidth: isFullWidth, // Aquí le indicas si es full-width
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
            child: Icon(config.icon,
                color: Colors.white, size: screenHeight <= 380 ? 18 : 30),
          ),
        ),
        Expanded(
          child: _buildTextFormField(
              config, screenHeight), // 🔹 Si no, usa TextField
        ),
      ],
    );
  }

  TextFormField _buildTextFormField(
      InputFieldConfig config, double screenHeight) {
    return TextFormField(
      focusNode: config.focusNode,
      controller: config.controller,
      cursorColor: Colors.white,
      autocorrect: false,
      keyboardType: config.keyboardType,
      style: TextFieldStyles.textFieldTextStyle(),
      decoration:
          TextFieldStyles.inputDecoration(screenHeight, config.hintText),
      validator: (value) {
        for (final validator in config.validator) {
          final result = validator(value);
          if (result != null)return result; // Si un validador falla, retorna el mensaje
        }
        return null; // Si ninguna validación falla, es válido
      },
      onTap: null,
      onChanged: (value) {},
      onFieldSubmitted: (_) {
        if (config.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(config.nextFocusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }

  //✅ widget image personalizado
  Widget buildImagePickerInput({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String? fileName,
    required String imagePath,
    required VoidCallback onTap,
    required double screenHeight,
    required double maxWidth,
    bool isFullWidth = false,
  }) {
    return Container(
      width: calcularAnchoDisponible(
        context: context,
        baseWidth: maxWidth,
        iconWidth: 40.0,
        paddingHorizontal: 6.8,
        isFullWidth: isFullWidth,
      ),
      height: screenHeight <= 640 ? 50 : 55,
      decoration: ContainerStyles.containerDecoration(),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ícono del costado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Container(
                height: 36,
                width: 38,
                decoration: ContainerStyles.containerIconDecoration(),
                child: Icon(icon,
                    color: Colors.white, size: screenHeight <= 380 ? 18 : 30),
              ),
            ),

            // Texto del archivo o label
            Expanded(
              child: Text(
                fileName != null && fileName.isNotEmpty ? fileName : label,
                style: TextFieldStyles.textFieldTextStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Miniatura de la imagen si hay imagePath
            if (imagePath.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(
                    File(imagePath),
                    width: 70,
                    height: 41,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
