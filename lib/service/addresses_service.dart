// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inri_driver/Generators/isolate_parse_json.dart';
import 'package:inri_driver/global/environment.dart';
import 'package:inri_driver/models/address.dart';
import 'package:inri_driver/models/usuario.dart';
import 'package:inri_driver/service/auth_service.dart';
import 'package:inri_driver/service/storage_service.dart';
import 'package:inri_driver/utils/functions.dart';


class AddressService {
  
  late AuthService authService;
  late Address address;
  Usuario? usuario;
  final storage = StorageService.instance;
  final funtions = Functions.instance;

  Future getAddressesBackground() async {
    
    final token = await storage.getTokenUser();
    final idUser = await storage.getId();

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token.toString()
    };

    final resp = await http.get(
        Uri.parse('${Environment.apiUrl}/drivers/$idUser'),
        headers: headers);

    if (resp.statusCode == 200) {
      final data = resp.body;

     

      storage.deleteIdOrder();

      final respuesta = await ParseData.instance.isolateFunction(data);
      
    
      final idOrder = respuesta.id;
      
      await storage.saveIdOrder(idOrder);

      return respuesta;
    }

    if (resp.statusCode == 201) {

      //convert data a Address Model
      await storage.deleteIdOrder();
      final date = Address(id: null);
      final result = date;

      return result;
    }

    if (resp.statusCode == 401) {

      await storage.deleteIdOrder();

      final date = Address(id: null);
      final result = date;
      return result;

    } else {
      return throw Exception('oops!');
    }
  }

  Future<Address> getAddresses() async {
    final token = await storage.getTokenUser();
    final idUser = await storage.getId();
    final newMap = {'id': null};    
    

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token.toString()
    };

    final resp = await http.get(
        Uri.parse('${Environment.apiUrl}/drivers/$idUser'),
        headers: headers);

    try {

      if (resp.statusCode == 200) {

      
      //data decoded
      final dataMap = jsonDecode(resp.body)["orderUser"];      
         
      //convert data a Address Model
      final Map<String, dynamic> response = dataMap ?? newMap;   
      final res = Address.fromJson(response);

           
      await storage.deleteIdOrder();
      await storage.saveIdOrder(res.id);
      
      return res;
    }

    if (resp.statusCode == 201) {

      //convert data a Address Model
      final date = jsonDecode(resp.body)["emptyObject"];
      final result = Address.fromJson(date);
      await storage.deleteIdOrder();

      final obj = result;
      return obj;

    } else {

      return Address(id: null);
    }
      
    } on FormatException catch (e) {
      
       return throw Exception(e);
    }    

    
  }

  Future<dynamic> updateEnCamino(Address address) async {

    final token = await StorageService.instance.getTokenUser();
    final idUser = await StorageService.instance.getId();

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token.toString()
    };

    final Map<String, dynamic> data = {
      '_id': idUser!,
      'order': 'en-camino',
      'viajes': 1
    };

    final resp = await http.put(
        Uri.parse('${Environment.apiUrl}/status/update'),
        headers: headers,
        body: json.encode(data));

    if (resp.statusCode == 200) {
      final Map<String, dynamic> driver = jsonDecode(resp.body);

      return driver;
    } else {
      return '';
    }
  }

  Future<dynamic> finishTravel(Address address) async {

    final token = await StorageService.instance.getTokenUser();
    final idUser = await StorageService.instance.getId();

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token.toString()
    };
    final Map<String, String> data = {'idDriver': idUser!, 'order': 'libre', 'status': 'disponible'};

    final resp = await http.put(
        Uri.parse('${Environment.apiUrl}/status/finish-travel'),
        headers: headers,
        body: json.encode(data));

    if (resp.statusCode == 200) {
      
      final Map<String, dynamic> address = jsonDecode(resp.body);

      return address;
    } else {
      return '';
    }
  }

  Future<dynamic> sendLocationBackground(driverPosition, idOrder) async {

    
    final token          = await StorageService.instance.getTokenUser();
    final idDriver       = await StorageService.instance.getId();
    final locationDriver = jsonEncode(driverPosition);

    print("******type position jsonEncode: $locationDriver****");

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token.toString()
    };

    final Map<String, dynamic> data = {
      'mensaje': locationDriver,
      'idDriver': idDriver!,
      'idOrder': idOrder
    };

    final resp = await http.put(
        Uri.parse('${Environment.apiUrl}/location/driver-position'),
        headers: headers,
        body: json.encode(data));

    if (resp.statusCode == 200) {
      final Map<String, dynamic> driverPosition = jsonDecode(resp.body);
     

      return driverPosition;
    } else {
      return '';
    }
  }

  Future<bool> updateHoraEsperaFin(String idOrder, DateTime horaFin) async {

  try {

  final token = await StorageService.instance.getTokenUser();
  final headers = {'Content-Type': 'application/json','x-token': token!};
  final body =  jsonEncode({"horaEsperaFin": horaFin.toIso8601String()}); 
  

  final resp = await http.put(
  Uri.parse('${Environment.apiUrl}/drivers/hora-espera-fin/$idOrder'),
  headers: headers, body: body);    
    

  if (resp.statusCode == 200 || resp.statusCode == 201) {
      final data = jsonDecode(resp.body);
      return data['ok'] == true;
    } else {
      print('❌ Error en respuesta del servidor: ${resp.statusCode}');
      return false;
    }
    
  } catch (e) {
    print('🛑 Excepción al enviar horaEsperaFin: $e');
    return false;
  }  

  

}

  Future<dynamic> arrivedDriver() async {

    final token = await StorageService.instance.getTokenUser();
    final idUser = await StorageService.instance.getId();


    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token.toString()
    };

    
    final Map<String, String> data = {'_id': idUser!, 'status': 'llego-conductor'};
   
    
    final resp = await http.put(
        Uri.parse('${Environment.apiUrl}/drivers/arrived'),
        headers: headers,
        body: json.encode(data)); 
     
    
    if (resp.statusCode == 200) {
      final Map<String, dynamic> arrivedDriver = jsonDecode(resp.body);

      return arrivedDriver;
    } else {
      return '';
    }
  }

  Future<dynamic> disconnectDriver() async {
     
    //DESCONNECT DRIVER 
    final token = await StorageService.instance.getTokenUser();
    final idUser = await StorageService.instance.getId();


    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token.toString()
    };

    const disconnect = false;
    final Map<String, dynamic> data = {'_id': idUser!, 'online': disconnect};
   
    
    final resp = await http.put(
        Uri.parse('${Environment.apiUrl}/drivers/disconnect'),
        headers: headers,
        body: json.encode(data)); 
    
    
    if (resp.statusCode == 200) {
      final Map<String, dynamic> arrivedDriver = jsonDecode(resp.body);

      return arrivedDriver;
    } else {
      return '';
    }
  }

}
