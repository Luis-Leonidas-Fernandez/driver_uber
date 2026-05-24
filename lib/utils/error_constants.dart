// Constantes para manejo de errores
// Centraliza la lógica de categorización de errores

class ErrorConstants {
  ErrorConstants._();

  // Patrones de error para categorización
  static const Map<String, String> errorPatterns = {
    'network': 'socketexception|network',
    'timeout': 'timeoutexception|timeout',
    'parse': 'formatexception|parse',
    'unauthorized': 'unauthorized|401',
    'forbidden': 'forbidden|403',
    'not_found': 'not found|404',
    'server_error': 'server error|500',
    'invalid_email': 'email.*invalid',
    'weak_password': 'password.*weak',
  };

  // Mensajes de error amigables
  static const Map<String, String> errorMessages = {
    'network': 'Sin conexión a internet. Verifica tu red.',
    'timeout': 'Tiempo de espera agotado. Intenta nuevamente.',
    'parse': 'Error al procesar la respuesta del servidor.',
    'unauthorized': 'Credenciales incorrectas. Verifica tu email y contraseña.',
    'forbidden': 'No tienes permisos para realizar esta acción.',
    'not_found': 'Servicio no disponible. Intenta más tarde.',
    'server_error': 'Error del servidor. Intenta más tarde.',
    'invalid_email': 'El formato del email no es válido.',
    'weak_password': 'La contraseña debe tener al menos 6 caracteres.',
    'unknown': 'Error inesperado. Intenta nuevamente.',
  };

  // Códigos de error
  static const Map<String, String> errorCodes = {
    'network': 'NETWORK_ERROR',
    'timeout': 'TIMEOUT_ERROR',
    'parse': 'PARSE_ERROR',
    'unauthorized': 'UNAUTHORIZED_ERROR',
    'forbidden': 'FORBIDDEN_ERROR',
    'not_found': 'NOT_FOUND_ERROR',
    'server_error': 'SERVER_ERROR',
    'invalid_email': 'INVALID_EMAIL_ERROR',
    'weak_password': 'WEAK_PASSWORD_ERROR',
    'unknown': 'UNKNOWN_ERROR',
  };
}
