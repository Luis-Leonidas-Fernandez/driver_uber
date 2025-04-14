part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class OnAddUserSessionEvent extends AuthEvent{ 
  
  final Usuario? usuario;
 
 const OnAddUserSessionEvent(this.usuario);
}

class OnAuthenticatingEvent extends AuthEvent{ 
   
 const OnAuthenticatingEvent();
}

class OnClearUserSessionEvent extends AuthEvent{ 
   
 const  OnClearUserSessionEvent();
}

/// ✅ Agregar una nuevo usuario
class RegisterUserEvent extends AuthEvent {}

// Usuario actualizado
class OnUpdateUserEvent extends AuthEvent {
  final Usuario usuarioActualizado;

  const OnUpdateUserEvent(this.usuarioActualizado);

  @override
  List<Object> get props => [usuarioActualizado];
}