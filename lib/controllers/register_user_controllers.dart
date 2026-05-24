
import 'package:flutter/material.dart';
import 'package:inri_driver/controllers/controllers_keys.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';



class RegisterUserController {

  final ImagePicker _picker = ImagePicker();

  final Map<String, TextEditingController> controllers = {

    ControllerKeys.email: TextEditingController(),
    ControllerKeys.password: TextEditingController(),
    ControllerKeys.nombre: TextEditingController(),
    ControllerKeys.apellido: TextEditingController(),
    ControllerKeys.fechaNacimiento: TextEditingController(),
    ControllerKeys.domicilio: TextEditingController(),

    ControllerKeys.vehiculo: TextEditingController(),
    ControllerKeys.modelo: TextEditingController(),
    ControllerKeys.patente: TextEditingController(),
    ControllerKeys.licencia: TextEditingController(),
    ControllerKeys.fotoDorso: TextEditingController(),
    ControllerKeys.fotoFrente: TextEditingController()
    
  };
  

  List<Map<String, dynamic>> cargasAcumuladas = [];  


  Map<String, dynamic> agregarNuevoUsuario() {  

    final fechaRaw = controllers[ControllerKeys.fechaNacimiento]?.text ?? '';
  final fechaNacimientoFormateada = _formatearFechaNacimiento(fechaRaw);

  final nuevaCarga = {
    "email": controllers[ControllerKeys.email]?.text ?? '',
    "password": controllers[ControllerKeys.password]?.text ?? '',      
    "nombre": controllers[ControllerKeys.nombre]?.text ?? '', 
    "apellido": controllers[ControllerKeys.apellido]?.text ?? '',
    "nacimiento": fechaNacimientoFormateada,
    "domicilio": controllers[ControllerKeys.domicilio]?.text ?? '',
    "vehiculo": controllers[ControllerKeys.vehiculo]?.text ?? '',
    "modelo": controllers[ControllerKeys.modelo]?.text ?? '',
    "patente": controllers[ControllerKeys.patente]?.text ?? '',
    "licencia": controllers[ControllerKeys.licencia]?.text ?? '',
    "fotoFrente": controllers[ControllerKeys.fotoFrente]?.text ?? '',
    "fotoDorso": controllers[ControllerKeys.fotoDorso]?.text ?? '',  


  };

  cargasAcumuladas = List.from(cargasAcumuladas)..add(nuevaCarga); 

  return nuevaCarga;

  
}

 void guardarValoresEnCargaController() {   
    controllers.forEach((key, controller) {          
});
        
}

  

  /// 🔥 Método para limpiar controladores sin borrar los que están en `excepto`
  void limpiarAllControllers({List<String> excepto = const []}) {
    controllers.forEach((key, controller) {
      if (!excepto.contains(key)) {
        controller.clear();
      }
    });
  }

  /// 🛠️ No olvides agregar `dispose()` para evitar memory leaks
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
  }

  String _formatearFechaNacimiento(String fechaInput) {
  try {
    // Asumiendo que la fecha viene como dd/MM/yyyy
    final parsed = DateFormat('dd/MM/yyyy').parseStrict(fechaInput);
    final formatoFinal = DateFormat('dd-MM-yyyy');
    return formatoFinal.format(parsed); // Ej: 10-04-2025
  } catch (e) {    
    return fechaInput; // Enviamos sin modificar si falla
  }
}



  

  String convertirFecha(String fecha) {

  if (fecha.contains('-')) {
      // ✅ Si la fecha ya está en formato ISO-8601, retornarla tal cual
      return fecha;
 }  
  final partes = fecha.split('/');
  if (partes.length != 3) return fecha; // Por si acaso no tiene el formato esperado

  final dia = partes[0];
  final mes = partes[1];
  final anio = partes[2];

  final fechaDateTime = DateTime.parse('$anio-$mes-$dia');
  return fechaDateTime.toUtc().toIso8601String().replaceFirst('Z', '+00:00');
}

Future<void> pickImage({
    required bool isFrente,
    required VoidCallback onChanged,
  }) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      final path = file.path;

      // Guardamos la ruta en el controlador correspondiente
      if (isFrente) {
        controllers[ControllerKeys.fotoFrente]?.text = path;
      } else {
        controllers[ControllerKeys.fotoDorso]?.text = path;
      }

      // Notificamos al UI
      onChanged();
    }
  }

  // Getters para mostrar el nombre de archivo seleccionado
  String get nombreFotoFrente {
    final path = controllers[ControllerKeys.fotoFrente]?.text ?? '';
    return path.split('/').last;
  }

  String get nombreFotoDorso {
    final path = controllers[ControllerKeys.fotoDorso]?.text ?? '';
    return path.split('/').last;
  }


}
