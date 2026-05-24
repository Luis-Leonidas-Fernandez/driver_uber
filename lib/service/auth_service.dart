import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inri_driver/global/environment.dart';
import 'package:inri_driver/models/login.dart';
import 'package:inri_driver/models/usuario.dart';
import 'package:inri_driver/service/storage_service.dart';
import 'package:inri_driver/utils/file_utils.dart';
import 'package:inri_driver/validation/auth_validation.dart';
import 'package:inri_driver/exceptions/auth_exceptions.dart';

class AuthService with ChangeNotifier {
  bool _autenticando = false;
  final storage = StorageService.instance;

  // Timeout para requests HTTP
  static const Duration _requestTimeout = Duration(seconds: 30);

//determina la autenticacion

  bool get autenticando => _autenticando;

  set autenticando(bool valor) {
    _autenticando = valor;

    notifyListeners();
  }

  //Registro de Usuario
  Future<LoginResponse> register(Map<String, dynamic> userData) async {
    try {
      // Validación de datos de entrada
      AuthValidation().validateRegistrationData(userData);

      final uri = Uri.parse('${Environment.apiUrl}/logindriver/newdriver');
      final request = http.MultipartRequest('POST', uri);

      // Configurar timeout
      request.headers['Accept'] = 'application/json';

      // Campos normales (enviar como String)
      _addFormFields(request, userData);

      // Archivos
      await _addImageFiles(request, userData);

      // Enviar request con timeout
      final streamed = await request.send().timeout(_requestTimeout);
      final resp = await http.Response.fromStream(streamed);

      // Procesar respuesta
      return _processRegisterResponse(resp);

      // // Campos normales (enviar como String)
      // request.fields['email'] = (userData['email'] ?? '').toString();
      // request.fields['password'] = (userData['password'] ?? '').toString();
      // request.fields['nombre'] = (userData['nombre'] ?? '').toString();
      // request.fields['apellido'] = (userData['apellido'] ?? '').toString();
      // request.fields['nacimiento'] = (userData['nacimiento'] ?? '').toString();
      // request.fields['domicilio'] = (userData['domicilio'] ?? '').toString();
      // request.fields['vehiculo'] = (userData['vehiculo'] ?? '').toString();
      // request.fields['modelo'] = (userData['modelo'] ?? '').toString();
      // request.fields['patente'] = (userData['patente'] ?? '').toString();
      // request.fields['licencia'] = (userData['licencia'] ?? '').toString();

      // // Archivos
      // await agregarImagenAlRequest(
      //   request: request,
      //   fieldName: 'fotoFrente',
      //   path: (userData['fotoFrente'] ?? '').toString(),
      // );

      // await agregarImagenAlRequest(
      //   request: request,
      //   fieldName: 'fotoDorso',
      //   path: (userData['fotoDorso'] ?? '').toString(),
      // );

      // // (Opcional) Acepto JSON de vuelta
      // request.headers['Accept'] = 'application/json';

      // // Enviar
      // final streamed = await request.send();
      // final resp = await http.Response.fromStream(streamed);

      // if (resp.statusCode == 200) {

      //   final loginResponse = loginResponseFromJson(resp.body);
      //   final usuario = loginResponse.usuario as Usuario;

      //   await storage.saveToken(loginResponse.token);
      //   await storage.saveId(usuario.id);

      //   return loginResponse;
      // } else {

      //   return LoginResponse(ok: false, usuario: null, token: '');
      // }
    } on ValidationException {
      rethrow;
    } on SocketException catch (e) {
      throw NetworkException(
        message: 'Sin conexión a internet. Verifica tu red.',
        originalError: e,
      );
    } on FormatException catch (e) {
      throw ParseException(
        message: 'Error al procesar los datos del servidor.',
        originalError: e,
      );
    } catch (e) {
      // Log del error original para debugging
      debugPrint('Error inesperado en register: $e');

      if (e is AuthException) {
        rethrow;
      }

      throw UnknownAuthException(
        message: 'Error inesperado durante el registro. Intenta nuevamente.',
        originalError: e,
      );
    }
  }

  Future<bool> isLoggedIn(String token) async {
    final token = await StorageService.instance.getTokenUser();

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-token': token.toString()
    };

    final resp = await http.get(Uri.parse('${Environment.apiUrl}/login/renew'),
        headers: headers);

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      loginResponse.usuario as Usuario;

      await storage.saveToken(loginResponse.token);

      return true;
    } else {
      await storage.logout();

      return false;
    }
  }

  Future<dynamic> loginUser(String email, String password) async {
    
    try {

    // Validación de datos de entrada
    AuthValidation().validateLoginData(email, password);

    final data = {'email': email, 'password': password};
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(data);

    final uri = Uri.parse('${Environment.apiUrl}/logindriver');

    // Enviar request con timeout
    final resp = await http.post(uri, body: body, headers: headers)
          .timeout(_requestTimeout);

    // Procesar respuesta
    return _processLoginResponse(resp);  
      
    } on ValidationException {
      rethrow;
    } on SocketException catch (e) {
      throw NetworkException(
        message: 'Sin conexión a internet. Verifica tu red.',
        originalError: e,
      );
    } on FormatException catch (e) {
      throw ParseException(
        message: 'Error al procesar los datos del servidor.',
        originalError: e,
      );
    } catch (e) {
      // Log del error original para debugging
      debugPrint('Error inesperado en login: $e');
      
      if (e is AuthException) {
        rethrow;
      }
      
      throw UnknownAuthException(
        message: 'Error inesperado durante el login. Intenta nuevamente.',
        originalError: e,
      );
    }
    

    // final resp = await http.post(Uri.parse('${Environment.apiUrl}/logindriver'),
    //     body: body, headers: headers);

    // if (resp.statusCode == 200) {
    //   final loginResponse = loginResponseFromJson(resp.body);

    //   final usuario = loginResponse.usuario as Usuario;

    //   final privateToken = loginResponse.token;

    //   await storage.saveToken(privateToken);
    //   await storage.saveId(usuario.id);
    //   await storage.saveNameDriver(usuario.nombre);

    //   return loginResponse;
    // } else {
    //   final response = LoginResponse(ok: false, usuario: null, token: '');

    //   return response;
    // }
  }

  
  
  
  /// Agregar campos del formulario al request
  void _addFormFields(
      http.MultipartRequest request, Map<String, dynamic> userData) {
    final fields = [
      'email',
      'password',
      'nombre',
      'apellido',
      'nacimiento',
      'domicilio',
      'vehiculo',
      'modelo',
      'patente',
      'licencia'
    ];

    for (final field in fields) {
      request.fields[field] = (userData[field] ?? '').toString();
    }
  }

  /// Agregar archivos de imagen al request
  Future<void> _addImageFiles(
      http.MultipartRequest request, Map<String, dynamic> userData) async {
    try {
      await agregarImagenAlRequest(
        request: request,
        fieldName: 'fotoFrente',
        path: (userData['fotoFrente'] ?? '').toString(),
      );

      await agregarImagenAlRequest(
        request: request,
        fieldName: 'fotoDorso',
        path: (userData['fotoDorso'] ?? '').toString(),
      );
    } catch (e) {
      throw ValidationException(
        message: 'Error al procesar las imágenes. Verifica que sean válidas.',
        originalError: e,
      );
    }
  }

  /// Procesar respuesta del registro
  Future<LoginResponse> _processRegisterResponse(http.Response resp) async {
    try {
      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);

        if (loginResponse.ok && loginResponse.usuario != null) {
          final usuario = loginResponse.usuario as Usuario;

          // Guardar datos en storage
          await _saveUserData(loginResponse.token, usuario.id);

          return loginResponse;
        } else {
          throw const ClientException(
            message: 'Error en el registro. Verifica tus datos.',
            code: 'REGISTER_FAILED',
          );
        }
      } else if (resp.statusCode >= 400 && resp.statusCode < 500) {
        // Error del cliente
        final errorMessage = _extractErrorMessage(resp.body);
        throw ClientException(
          message:
              errorMessage ?? 'Datos incorrectos. Verifica la información.',
          code: 'CLIENT_ERROR_${resp.statusCode}',
        );
      } else if (resp.statusCode >= 500) {
        // Error del servidor
        throw ServerException(
          message: 'Error del servidor. Intenta más tarde.',
          code: 'SERVER_ERROR_${resp.statusCode}',
        );
      } else {
        throw UnknownAuthException(
          message: 'Respuesta inesperada del servidor.',
          code: 'UNEXPECTED_STATUS_${resp.statusCode}',
        );
      }
    } catch (e) {
      if (e is AuthException) rethrow;

      throw ParseException(
        message: 'Error al procesar la respuesta del registro.',
        originalError: e,
      );
    }
  }

    /// Procesar respuesta del login
  Future<LoginResponse> _processLoginResponse(http.Response resp) async {
    try {
      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        
        if (loginResponse.ok && loginResponse.usuario != null) {
          final usuario = loginResponse.usuario as Usuario;
          
          // Guardar datos en storage
          await _saveUserData(loginResponse.token, usuario.id);
          await storage.saveNameDriver(usuario.nombre);
          
          return loginResponse;
        } else {
          throw const ClientException(
            message: 'Credenciales incorrectas. Verifica tu email y contraseña.',
            code: 'LOGIN_FAILED',
          );
        }
      } else if (resp.statusCode == 401) {
        throw const ClientException(
          message: 'Credenciales incorrectas. Verifica tu email y contraseña.',
          code: 'UNAUTHORIZED',
        );
      } else if (resp.statusCode >= 400 && resp.statusCode < 500) {
        final errorMessage = _extractErrorMessage(resp.body);
        throw ClientException(
          message: errorMessage ?? 'Error en la solicitud. Verifica tus datos.',
          code: 'CLIENT_ERROR_${resp.statusCode}',
        );
      } else if (resp.statusCode >= 500) {
        throw ServerException(
          message: 'Error del servidor. Intenta más tarde.',
          code: 'SERVER_ERROR_${resp.statusCode}',
        );
      } else {
        throw UnknownAuthException(
          message: 'Respuesta inesperada del servidor.',
          code: 'UNEXPECTED_STATUS_${resp.statusCode}',
        );
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      
      throw ParseException(
        message: 'Error al procesar la respuesta del login.',
        originalError: e,
      );
    }
  }

  /// Guardar datos del usuario en storage
  Future<void> _saveUserData(String token, String userId) async {
    try {
      await storage.saveToken(token);
      await storage.saveId(userId);
    } catch (e) {
      throw StorageException(
        message: 'Error al guardar la sesión del usuario.',
        originalError: e,
      );
    }
  }

  /// Extraer mensaje de error del response body
  String? _extractErrorMessage(String responseBody) {
    try {
      final Map<String, dynamic> response = json.decode(responseBody);
      return response['message'] ?? response['error'] ?? response['msg'];
    } catch (e) {
      return null;
    }
  }
}
