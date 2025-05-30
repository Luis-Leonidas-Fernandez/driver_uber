import 'dart:convert';

import 'package:inri_driver/global/environment.dart';
import 'package:inri_driver/service/storage_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {

SocketService._internal();

static final SocketService _instance = SocketService._internal();
static SocketService get instance => _instance;

Socket? socket;
final storage = StorageService.instance;

// Funcion que inicializara la coneccion del Socket
 void initSocket({required String token}) async {

  // 🛑 Cierre total del socket anterior
  if (socket != null) {
   
    socket!.offAny();
    socket!.clearListeners();
    socket!.disconnect();
    socket = null;
  }


     if (token.isEmpty) { return; }
    
     await Future.delayed(const Duration(seconds: 2));
    

   socket = io(
      Environment.urlSocket,
      OptionBuilder()
      .setTransports(['websocket'])
      .setTimeout(3000)
      .setReconnectionDelay(5000)
      .disableAutoConnect()
      .enableForceNew()
      .setExtraHeaders({'x-token': token})
      .build()
      
      );

     socket!.connect();
     

     socket!.onConnect((_) {    
     
     socket!.emit('msg', '******conectado*****'); 
       

    });

      //Escuchara eventos del servidor de tipo connect
     socket!.on('connect', (_) {
      
    });

    //Escuchara eventos del servidor de tipo connect-error
     socket!.on('connect_error', (data) {      
      
    });

    //Escuchara eventos del servidor de tipo error
     socket!.on('error', (data) {
    
      
    });
    
    //Escuchara eventos del servidor de tipo disconnect
     socket!.on('disconnect', (data) {  
      
    });

  }
  
  //Funcion encargada de emitir una ubicacion al servidor
  void sendLocation(dynamic driverPosition, dynamic idOrder)async{

    
    final idDriver =  await StorageService.instance.getId();  
    
    
    await Future.delayed(const Duration(seconds: 2));    
    
    final data = jsonEncode(driverPosition);      
    
    final sock =socket?.connected;    
  
    
    if(sock == false){

      return;
    }else{

      socket!.emit('driver-location', {
      'mensaje': data,
      'idDriver': idDriver,
      'idOrder' : idOrder,
    });    
    
     
    }
    
  } 

  Future<bool> testSocket() async {
    
    final isConnectSocket = socket;
    
    if(isConnectSocket == null){
      return false;
    }
    return true;
  }
  
  
  //Funcion encargada de finalizar la coneccion del socket 
  void finishSocket(){
   
    socket?.onDisconnect((data) => data);
    if (socket != null) {
    socket!.clearListeners();  
    socket!.offAny();
    socket!.disconnect();
    socket!.destroy();
    socket!.dispose();
    socket = null;
   
  }
      
  }

}