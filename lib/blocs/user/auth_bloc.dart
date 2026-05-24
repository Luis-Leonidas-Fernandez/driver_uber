import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inri_driver/controllers/register_user_controllers.dart';
import 'package:inri_driver/models/login.dart';
import 'package:inri_driver/models/usuario.dart';
import 'package:inri_driver/service/auth_service.dart';
import 'package:inri_driver/service/socket_service.dart';
import 'package:inri_driver/utils/error_utils.dart';
import 'package:inri_driver/exceptions/auth_exceptions.dart';


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
    on<OnClearUserSessionEvent>((event, emit) {
     registerUserController.limpiarAllControllers(); // o registerUserController.reinit();
     emit(const UserSessionInitialState());
   });
    on<OnAddUserSessionEvent>((event, emit) {     
    emit(state.copyWith(    
      usuario: event.usuario,
      autenticando: true,    
    ));
    });

    on<OnUpdateUserEvent>((event, emit) {
    emit(state.copyWith(usuario: event.usuarioActualizado));
    });

    on<OnRegisterErrorEvent>((event, emit) => emit(
      UserRegisterErrorState(
        message: event.message,
        errorCode: event.errorCode,
      )
    ));

    on<OnLoginErrorEvent>((event, emit) => emit(
      UserLoginErrorState(
        message: event.message,
        errorCode: event.errorCode,
      )
    ));

    on<OnClearErrorEvent>((event, emit) => emit(
      state.copyWith(
        errorMessage: null,
        errorCode: null,
        hasError: false,
      )
    ));

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

  Future<void> _sendUser(
    RegisterUserEvent event,
    Emitter<AuthState> emit
    ) async {
    try {
      emit(const UserRegisteringState());
      
      final usuario = await _initRegister();

      if(usuario is Usuario && usuario.id.isNotEmpty){
        add(OnAddUserSessionEvent(usuario));
      } else {
        add(const OnRegisterErrorEvent(
          message: 'Error en el registro. Verifica tus datos.',
        ));
      }
    } on NetworkException catch (e) {
      add(OnRegisterErrorEvent(
        message: e.message,
        errorCode: e.code,
      ));
    } on ServerException catch (e) {
      add(OnRegisterErrorEvent(
        message: e.message,
        errorCode: e.code,
      ));
    } on ClientException catch (e) {
      add(OnRegisterErrorEvent(
        message: e.message,
        errorCode: e.code,
      ));
    } on ValidationException catch (e) {
      add(OnRegisterErrorEvent(
        message: e.message,
        errorCode: e.code,
      ));
    } on TimeoutException catch (e) {
      add(OnRegisterErrorEvent(
        message: e.message,
        errorCode: e.code,
      ));
    } on ParseException catch (e) {
      add(OnRegisterErrorEvent(
        message: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      ErrorUtils.handleError(e, 'register', (message, errorCode) {
        add(OnRegisterErrorEvent(message: message, errorCode: errorCode));
      });
    }
  } 

  Future<Usuario?> _initRegister() async {
    try {
      final userData = registerUserController.agregarNuevoUsuario();
      
      final LoginResponse registerResponse = await authService.register(userData);  
     
      if (registerResponse.ok && registerResponse.usuario != null) {
        final usuario = registerResponse.usuario as Usuario;
        final token = registerResponse.token;
        
        if(usuario.id.isNotEmpty){
          registerUserController.limpiarAllControllers();
          SocketService.instance.initSocket(token: token);
        } 
        
        return usuario;
      } else {
        throw Exception('Error en el registro: Datos incorrectos');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> initLogin(String email, String password) async {
    try {
      add(const OnAuthenticatingEvent());
      
      final login = await authService.loginUser(email, password);
      final LoginResponse loginResponse = login as LoginResponse;
      final usuario = loginResponse.usuario as Usuario;
     
      if(usuario.id.isNotEmpty){
        add(OnAddUserSessionEvent(usuario));        
        return true;
      } else {  
        add(const OnLoginErrorEvent(
          message: 'Credenciales incorrectas.',
        ));
        return false;
      }    
    } on NetworkException catch (e) {
      add(OnLoginErrorEvent(
        message: e.message,
        errorCode: e.code,
      ));
      return false;
    } on ServerException catch (e) {
      add(OnLoginErrorEvent(
        message: e.message,
        errorCode: e.code,
      ));
      return false;
    } on ClientException catch (e) {
      add(OnLoginErrorEvent(
        message: e.message,
        errorCode: e.code,
      ));
      return false;
    } on ValidationException catch (e) {
      add(OnLoginErrorEvent(
        message: e.message,
        errorCode: e.code,
      ));
      return false;
    } on TimeoutException catch (e) {
      add(OnLoginErrorEvent(
        message: e.message,
        errorCode: e.code,
      ));
      return false;
    } on ParseException catch (e) {
      add(OnLoginErrorEvent(
        message: e.message,
        errorCode: e.code,
      ));
      return false;
    } catch (e) {
      ErrorUtils.handleError(e, 'login', (message, errorCode) {
        add(OnLoginErrorEvent(message: message, errorCode: errorCode));
      });
      return false;
    }
  }

  void deleteUser(){
   add(const OnClearUserSessionEvent());
  }

  void clearError() {
    add(const OnClearErrorEvent());
  }


  @override
  Future<void> close() {
    deleteUser();
    return super.close();
  }  


}

