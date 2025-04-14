class InputFieldValidator {


  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Correo es obligatorio';
    }
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Correo inválido';
    }
    return null;
  }

 
  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contraseña es obligatoria';
    }
    if (value.length < 8) {
      return 'Debe tener al menos 8 caracteres';
    }
    final hasUpperCase = RegExp(r'[A-Z]');
    final hasNumber = RegExp(r'\d');
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (!hasUpperCase.hasMatch(value)) {
      return 'Debe contener al menos 1 letra mayúscula';
    }
    if (!hasNumber.hasMatch(value)) {
      return 'Debe contener al menos 1 número';
    }
    if (!hasSpecialChar.hasMatch(value)) {
      return 'Debe contener al menos 1 carácter especial';
    }
    return null;
  }


  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }

  static String? textOnly(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    final textRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$'); // Permite letras y espacios
    if (!textRegex.hasMatch(value)) {
      return 'Solo se permiten letras';
    }
    return null;
  }

  static String? numeric(String? value) {
  
    if (value == null || value.trim().isEmpty) return 'Campo obligatorio';
    if (double.tryParse(value) == null) return 'Debe ser un número válido';
    return null;
  }

  static String? date(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obligatorio';
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regex.hasMatch(value)) return 'Formato inválido (dd/mm/yyyy)';
    return null;
  }


  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }
    final phoneRegex = RegExp(r'^\d{8,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Número de teléfono no válido (8 a 15 dígitos)';
    }
    return null;
  }
}


