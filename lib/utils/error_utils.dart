// Clase utilitaria para manejo de errores
// Separada del BLoC para mejor organización y reutilización

import 'package:inri_driver/utils/error_constants.dart';

class ErrorUtils {
  ErrorUtils._();

  // Método simplificado para manejo de errores
  static void handleError(dynamic error, String operation, Function(String message, String? errorCode) onError) {
    onError(
      getErrorMessage(error),
      getErrorCode(error),
    );
  }

  static String getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    for (final entry in ErrorConstants.errorPatterns.entries) {
      if (RegExp(entry.value).hasMatch(errorString)) {
        return ErrorConstants.errorMessages[entry.key] ?? ErrorConstants.errorMessages['unknown']!;
      }
    }
    
    return ErrorConstants.errorMessages['unknown']!;
  }

  static String? getErrorCode(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    for (final entry in ErrorConstants.errorPatterns.entries) {
      if (RegExp(entry.value).hasMatch(errorString)) {
        return ErrorConstants.errorCodes[entry.key] ?? ErrorConstants.errorCodes['unknown'];
      }
    }
    
    return ErrorConstants.errorCodes['unknown'];
  }
}
