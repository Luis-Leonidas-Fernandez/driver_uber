part of 'auth_bloc.dart';

class AuthState extends Equatable {
  
final bool? authenticando;
final Usuario? usuario;

  const AuthState({
  this.authenticando = false,   
  this.usuario, 
});

 AuthState copyWith({   
    Usuario? usuario,
    bool? autenticando
  }) => AuthState(    
    authenticando: authenticando?? authenticando,
    usuario: usuario?? usuario
  );

  @override
  List<Object?> get props => [ authenticando, usuario ];


}

class UserSessionInitialState extends AuthState {
  const UserSessionInitialState(): super( authenticando: false, usuario: null);
}

/// ✅ Estado cuando se está esta creando un usuario para registrarlo en DB
class UserLoadState extends AuthState {}





  

  

  

