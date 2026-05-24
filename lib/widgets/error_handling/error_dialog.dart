// Widget para mostrar errores de manera consistente
// Este widget puede ser reutilizado en toda la aplicación

import 'package:flutter/material.dart';
import 'package:inri_driver/blocs/user/auth_bloc.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final String? errorCode;
  final AuthExceptionType errorType;
  final VoidCallback? onRetry;

  const ErrorDialog({
    Key? key,
    required this.message,
    this.errorCode,
    required this.errorType,
    this.onRetry,
  }) : super(key: key);

  // Factory constructor para crear desde AuthErrorState
  factory ErrorDialog.fromAuthErrorState(
    AuthErrorState state, {
    VoidCallback? onRetry,
  }) {
    return ErrorDialog(
      message: state.errorMessage ?? 'Error desconocido',
      errorCode: state.errorCode,
      errorType: state.errorType ?? AuthExceptionType.unknown,
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            _getErrorIcon(),
            color: _getErrorColor(),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getErrorTitle(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          if (errorCode != null) ...[
            const SizedBox(height: 8),
            Text(
              'Código: $errorCode',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontFamily: 'monospace',
              ),
            ),
          ],
          if (errorType == AuthExceptionType.network) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Verifica tu conexión a internet',
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (onRetry != null && _canRetry())
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry!();
            },
            child: const Text('Reintentar'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            _canRetry() ? 'Cancelar' : 'Entendido',
            style: TextStyle(
              color: _getErrorColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getErrorIcon() {
    switch (errorType) {
      case AuthExceptionType.network:
        return Icons.wifi_off;
      case AuthExceptionType.server:
        return Icons.cloud_off;
      case AuthExceptionType.client:
        return Icons.error_outline;
      case AuthExceptionType.validation:
        return Icons.warning_amber_outlined;
      case AuthExceptionType.timeout:
        return Icons.timer_off;
      case AuthExceptionType.storage:
        return Icons.storage;
      case AuthExceptionType.parse:
        return Icons.bug_report_outlined;
      case AuthExceptionType.unknown:
        return Icons.help_outline;
    }
  }

  Color _getErrorColor() {
    switch (errorType) {
      case AuthExceptionType.network:
        return Colors.blue;
      case AuthExceptionType.server:
        return Colors.red;
      case AuthExceptionType.client:
        return Colors.orange;
      case AuthExceptionType.validation:
        return Colors.amber;
      case AuthExceptionType.timeout:
        return Colors.purple;
      case AuthExceptionType.storage:
        return Colors.brown;
      case AuthExceptionType.parse:
        return Colors.teal;
      case AuthExceptionType.unknown:
        return Colors.grey;
    }
  }

  String _getErrorTitle() {
    switch (errorType) {
      case AuthExceptionType.network:
        return 'Sin conexión';
      case AuthExceptionType.server:
        return 'Error del servidor';
      case AuthExceptionType.client:
        return 'Datos incorrectos';
      case AuthExceptionType.validation:
        return 'Validación fallida';
      case AuthExceptionType.timeout:
        return 'Tiempo agotado';
      case AuthExceptionType.storage:
        return 'Error de almacenamiento';
      case AuthExceptionType.parse:
        return 'Error de datos';
      case AuthExceptionType.unknown:
        return 'Error desconocido';
    }
  }

  bool _canRetry() {
    switch (errorType) {
      case AuthExceptionType.network:
      case AuthExceptionType.server:
      case AuthExceptionType.timeout:
      case AuthExceptionType.unknown:
        return true;
      case AuthExceptionType.client:
      case AuthExceptionType.validation:
      case AuthExceptionType.storage:
      case AuthExceptionType.parse:
        return false;
    }
  }
}

// Función helper para mostrar error dialog
void showErrorDialog(
  BuildContext context, {
  required String message,
  String? errorCode,
  required AuthExceptionType errorType,
  VoidCallback? onRetry,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ErrorDialog(
      message: message,
      errorCode: errorCode,
      errorType: errorType,
      onRetry: onRetry,
    ),
  );
}

// Función helper para mostrar error desde AuthErrorState
void showAuthErrorDialog(
  BuildContext context,
  AuthErrorState state, {
  VoidCallback? onRetry,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ErrorDialog.fromAuthErrorState(
      state,
      onRetry: onRetry,
    ),
  );
}
