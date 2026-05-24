import 'package:inri_driver/exceptions/auth_exceptions.dart';

class AuthValidation {
    /// Validación de datos de registro
  void validateRegistrationData(Map<String, dynamic> userData) {

    final requiredFields = [
      'email', 'password', 'nombre', 'apellido', 'nacimiento',
      'domicilio', 'vehiculo', 'modelo', 'patente', 'licencia'
    ];

    for (final field in requiredFields) {

      if (userData[field] == null || userData[field].toString().trim().isEmpty) {
        throw ValidationException(
          message: 'El campo ${_getFieldDisplayName(field)} es obligatorio.',
          code: 'MISSING_FIELD_$field',
        );
      }
    }

    // Validación específica de email
    final email = userData['email'].toString().trim();
    if (!_isValidEmail(email)) {
      throw const ValidationException(
        message: 'El formato del email no es válido.',
        code: 'INVALID_EMAIL',
      );
    }

    // Validación de contraseña
    final password = userData['password'].toString();
    if (password.length < 8) {
      throw const ValidationException(
        message: 'La contraseña debe tener al menos 8 caracteres.',
        code: 'WEAK_PASSWORD',
      );
    }
  }


  /// Obtener nombre amigable del campo
  String _getFieldDisplayName(String field) {
    const fieldNames = {
      'email': 'Email',
      'password': 'Contraseña',
      'nombre': 'Nombre',
      'apellido': 'Apellido',
      'nacimiento': 'Fecha de nacimiento',
      'domicilio': 'Domicilio',
      'vehiculo': 'Vehículo',
      'modelo': 'Modelo',
      'patente': 'Patente',
      'licencia': 'Licencia',
    };
    return fieldNames[field] ?? field;
  }

  /// Validación simple de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validación de datos de login
  void validateLoginData(String email, String password) {
    if (email.trim().isEmpty) {
      throw const ValidationException(
        message: 'El email es obligatorio.',
        code: 'MISSING_EMAIL',
      );
    }

    if (password.trim().isEmpty) {
      throw const ValidationException(
        message: 'La contraseña es obligatoria.',
        code: 'MISSING_PASSWORD',
      );
    }

    if (!_isValidEmail(email.trim())) {
      throw const ValidationException(
        message: 'El formato del email no es válido.',
        code: 'INVALID_EMAIL',
      );
    }
  }
  
     

}