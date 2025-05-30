import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inri_driver/controllers/register_user_controllers.dart';
import 'package:inri_driver/models/login.dart';
import 'package:inri_driver/models/usuario.dart';
import 'package:inri_driver/service/auth_service.dart';
import 'package:inri_driver/service/socket_service.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {

  final RegisterUserController registerUserController;
  AuthService authService;

  AuthBloc(
    {required this.authService,
    required this.registerUserController
    }) : super(const AuthState(authenticando: false, usuario:  null)) {

    on<RegisterUserEvent>(_sendUser);
    on<OnAuthenticatingEvent>((event, emit) => emit(state.copyWith(autenticando: true)));
    on<OnClearUserSessionEvent>((event, emit) => emit(const UserSessionInitialState()));
    on<OnAddUserSessionEvent>((event, emit) {     
    emit(state.copyWith(    
      usuario: event.usuario,
      autenticando: true,    
    ));
    });

    on<OnUpdateUserEvent>((event, emit) {
    emit(state.copyWith(usuario: event.usuarioActualizado));
    });

  }

  

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    
    try {

    final usuario = Usuario.fromJson(json);
    return AuthState(usuario: usuario, authenticando: false);

  } catch (e) {
    
    return null;
  }
  }
  
  @override
  Map<String, dynamic>? toJson(AuthState state) {
       
      if(state.usuario != null){
      return state.usuario!.toJson();           
      
     }else{
      return null;
     }     
  }

  void _sendUser(RegisterUserEvent event, Emitter<AuthState> emit) {
    _initRegister();
  } 

  Future<bool> _initRegister( ) async {

    final userData = registerUserController.agregarNuevoUsuario();
    final LoginResponse registerResponse = await authService.register(userData);  
   
    final usuario = registerResponse.usuario as Usuario;
    final token = registerResponse.token;
     if(usuario.id.isNotEmpty){
   
    add(OnAddUserSessionEvent(usuario));
    registerUserController.limpiarAllControllers();
    SocketService.instance.initSocket(token: token);
  
     
      return true;
     }else{

      return false;
     }    

  }

  Future<bool> initLogin(String email, String password) async {

    
    final login = await authService.loginUser(email, password);
    final LoginResponse loginResponse = login as LoginResponse;
    final usuario = loginResponse.usuario as Usuario;
   
 
     if(usuario.id.isNotEmpty){

      add(OnAddUserSessionEvent(usuario));        
      
      return true;
     }else{  
       
      return false;
     }    

  }

  void deleteUser(){
   add(const OnClearUserSessionEvent());
  }

  @override
  Future<void> close() {
    deleteUser();
    return super.close();
  }  


}

