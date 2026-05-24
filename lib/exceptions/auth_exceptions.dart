// Excepciones personalizadas para el sistema de autenticación
// Estas clases proporcionan manejo de errores más específico y útil

/// Excepción base para errores de autenticación
abstract class AuthException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AuthException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AuthException: $message';
}

/// Error de red/conectividad
class NetworkException extends AuthException {
  const NetworkException({
    String message = 'Error de conexión. Verifica tu internet.',
    String? code,
    dynamic originalError,
  }) : super(message: message, code: code, originalError: originalError);
}

/// Error de servidor (5xx)
class ServerException extends AuthException {
  const ServerException({
    String message = 'Error del servidor. Intenta más tarde.',
    String? code,
    dynamic originalError,
  }) : super(message: message, code: code, originalError: originalError);
}

/// Error de cliente (4xx) - datos incorrectos
class ClientException extends AuthException {
  const ClientException({
    required String message,
    String? code,
    dynamic originalError,
  }) : super(message: message, code: code, originalError: originalError);
}

/// Error de validación de datos
class ValidationException extends AuthException {
  const ValidationException({
    required String message,
    String? code,
    dynamic originalError,
  }) : super(message: message, code: code, originalError: originalError);
}

/// Error de parseo de respuesta
class ParseException extends AuthException {
  const ParseException({
    String message = 'Error al procesar la respuesta del servidor.',
    String? code,
    dynamic originalError,
  }) : super(message: message, code: code, originalError: originalError);
}

/// Error de timeout
class TimeoutException extends AuthException {
  const TimeoutException({
    String message = 'Tiempo de espera agotado. Intenta nuevamente.',
    String? code,
    dynamic originalError,
  }) : super(message: message, code: code, originalError: originalError);
}

/// Error de almacenamiento local
class StorageException extends AuthException {
  const StorageException({
    String message = 'Error al guardar datos localmente.',
    String? code,
    dynamic originalError,
  }) : super(message: message, code: code, originalError: originalError);
}

/// Error desconocido
class UnknownAuthException extends AuthException {
  const UnknownAuthException({
    String message = 'Error desconocido. Contacta soporte.',
    String? code,
    dynamic originalError,
  }) : super(message: message, code: code, originalError: originalError);
}
