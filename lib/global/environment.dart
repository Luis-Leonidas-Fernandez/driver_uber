//import 'dart:io';

class Environment {
  // Entorno dinámico (dev o prod)
  static bool get isProduction => true;
  //const bool.fromEnvironment('dart.vm.product');

  // URLs de desarrollo
  static const String _devApiUrl     = 'http://10.0.2.2:3000/api';
  static const String _devSocketUrl  = 'http://10.0.2.2:3000';

  // URLs de producción
  static const String _prodApiUrl    = 'https://www.inriservice.com/api';
  static const String _prodSocketUrl = 'https://www.inriservice.com';

  // Accesibles desde tu app como `Environment.apiUrl`
  static String get apiUrl    => isProduction ? _prodApiUrl : _devApiUrl;
  static String get urlSocket => isProduction ? _prodSocketUrl : _devSocketUrl;
}

