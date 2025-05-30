import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {

 //Instanciando class Storage Service
 StorageService._internal();
 static final StorageService _instance = StorageService._internal();
 static StorageService get instance => _instance;


  //Config Storage Service para android
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
     encryptedSharedPreferences: true,
   );
  
  // Config Storage para ios
  // ignore: unused_element
   IOSOptions _getIOSOptions() => const IOSOptions(
    accountName: AppleOptions.defaultAccountName,
   );

  final storage = const FlutterSecureStorage( );
  

  // Obteniendo el token 
  Future<String?> getTokenUser() async {        
  final token = await storage.read(key: 'token', aOptions: _getAndroidOptions());    
   return token.toString(); 
  }

  //Guardar token en storage
  Future saveToken( String? token ) async {  
  return await storage.write(key: 'token', value: token, aOptions: _getAndroidOptions() );
  } 

  //Eliminar token y cerrar sesion
  Future logout() async {    
   return await storage.delete(key: 'token', aOptions: _getAndroidOptions());
   
  }  

  // Guardando ID del driver
  Future saveId( String? id ) async {
    return await storage.write(key: 'id', value: id, aOptions: _getAndroidOptions() );
  }

  // Obteniendo ID del driver
  Future<String?> getId() async {      
    final id = await storage.read(key: 'id', aOptions: _getAndroidOptions());       
    return id; 
  }

  // Obteniendo ID del driver
   Future<void> deleteId() async {      
     await storage.delete(key: 'id', aOptions: _getAndroidOptions());       
      
  }

  // Guardando NOMBRE del conductor
  Future saveNameDriver(String? name) async {      
     await storage.write(key: 'name', value: name, aOptions: _getAndroidOptions());       
      
  }

  // Obteniendo ID del driver
  Future<String?> getNameDriver() async {      
    final name = await storage.read(key: 'name', aOptions: _getAndroidOptions());       
    return name; 
  }



  // Guardando ID de la Order
  Future saveIdOrder( String? idOrder ) async {
    return await storage.write(key: 'idOrder', value: idOrder, aOptions: _getAndroidOptions() );
  }

   // Obteniendo ID de la Orden
   Future<String?> getIdOrder() async {      
    final idOrder = await storage.read(key: 'idOrder', aOptions: _getAndroidOptions());       
    return idOrder; 
  }

  // Obteniendo ID del driver
  Future<void> deleteIdOrder() async {      
     await storage.delete(key: 'idOrder', aOptions: _getAndroidOptions());       
      
  }
   //manejo de notificaciones

  Future<void> saveNotified(String? orderId) async {
    await storage.write(key: 'notified_$orderId', value: 'true');
  }

   // Consultar si ya fue notificado por id de orden
  Future<bool> isAlreadyNotified(String? orderId) async {
    final value = await storage.read(key: 'notified_$orderId');
    return value == 'true';
  }

  // Limpiar notificación previa (opcional si querés resetear)
  Future<void> clearNotified(String? orderId) async {
    await storage.delete(key: 'notified_$orderId');
  }

  

}