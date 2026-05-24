part of 'auth_bloc.dart';

// Tipos de error para facilitar el manejo en la UI
enum AuthExceptionType {
  network,
  server,
  client,
  validation,
  parse,
  timeout,
  storage,
  unknown,
}

class AuthState extends Equatable {
  
final bool? authenticando;
final Usuario? usuario;

final String? errorMessage;
final String? errorCode;
final bool hasError;
final AuthExceptionType? errorType;

const AuthState({
  this.authenticando = false,   
  this.usuario,
  this.errorMessage,
  this.errorCode,
  this.hasError = false,
  this.errorType,
});

 AuthState copyWith({   
    Usuario? usuario,
    bool? autenticando,
    String? errorMessage,
    String? errorCode,
    bool? hasError,
    AuthExceptionType? errorType,
  }) => AuthState(    
    authenticando: autenticando ?? authenticando,
    usuario: usuario ?? this.usuario,
    errorMessage: errorMessage ?? this.errorMessage,
    errorCode: errorCode ?? this.errorCode,
    hasError: hasError ?? this.hasError,
    errorType: errorType ?? this.errorType,
  );

  @override
  List<Object?> get props => [ authenticando, usuario, errorCode, errorMessage, hasError, errorType ];


}

class UserSessionInitialState extends AuthState {
  const UserSessionInitialState(): super( authenticando: false, usuario: null);
}

/// ✅ Estado cuando se está esta creando un usuario para registrarlo en DB
class UserLoadState extends AuthState {}

class UserRegisteringState extends AuthState {
  const UserRegisteringState(): super(authenticando: true, usuario: null);
}

class UserLoggingInState extends AuthState {
  const UserLoggingInState(): super(authenticando: true, usuario: null);
}


class UserRegisterErrorState extends AuthState {
  const UserRegisterErrorState({
    required String message,
    String? errorCode,
  }): super(
    authenticando: false, 
    usuario: null, 
    hasError: true, 
    errorCode: errorCode,
    errorMessage: message,
  );
  
  @override
  List<Object?> get props => [errorMessage, errorCode];
}

class UserLoginErrorState extends AuthState {
  const UserLoginErrorState({
    required String message,
    String? errorCode,
  }): super(
    authenticando: false, 
    usuario: null, 
    hasError: true, 
    errorCode: errorCode,
    errorMessage: message,
  );
  
  @override
  List<Object?> get props => [errorMessage, errorCode];
}

/// Estado genérico para errores de autenticación
class AuthErrorState extends AuthState {
  const AuthErrorState({
    required String message,
    String? errorCode,
    required AuthExceptionType errorType,
  }): super(
    authenticando: false, 
    usuario: null, 
    hasError: true, 
    errorCode: errorCode,
    errorType: errorType,
    errorMessage: message,
  );
  
  @override
  List<Object?> get props => [errorMessage, errorCode, errorType];
}




  

  

  

