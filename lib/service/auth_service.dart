

import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:inri_driver/global/environment.dart';
import 'package:inri_driver/models/login.dart';
import 'package:inri_driver/models/usuario.dart';

import 'package:inri_driver/service/storage_service.dart';


class AuthService with ChangeNotifier {

bool _autenticando = false;
final storage = StorageService.instance;

//determina la autenticacion

bool get autenticando => _autenticando;

set autenticando( bool valor ) {
  _autenticando = valor;

  notifyListeners();
}  

  

    //Registro de Usuario
    Future<dynamic> register( Map<String, dynamic> userData ) async {
     
    final body = jsonEncode(userData);
    final headers = {'Content-Type': 'application/json'};

    final resp = await http.post(Uri.parse('${Environment.apiUrl }/logindriver/newdriver'), body: body, headers: headers);       
   

    if ( resp.statusCode == 200 ) {
    
    final loginResponse = loginResponseFromJson( resp.body );
    final usuario = loginResponse.usuario as Usuario;   

    await storage.saveToken(loginResponse.token);
    await storage.saveId(usuario.id);

    return loginResponse;
    
    } else {


      final response =  LoginResponse(
        ok: false,
        usuario: null,
        token: '');
      
      return response;
    }

  }

  Future<bool> isLoggedIn(String token) async {
    
    final token  = await StorageService.instance.getTokenUser();
    
    final Map<String, String> headers = {'Content-Type': 'application/json', 'x-token': token.toString()};
  
    
    final resp = await http.get( Uri.parse('${Environment.apiUrl }/login/renew'),   headers: headers);

    if ( resp.statusCode == 200 ) {

      final loginResponse = loginResponseFromJson( resp.body );
      loginResponse.usuario as Usuario;

      await storage.saveToken(loginResponse.token);

      return true;

    } else {

      await storage.logout();

      return false;
    }

  }

  Future<dynamic> loginUser( String email, String password ) async {    
   

    final data = {'email': email, 'password': password};
    final headers = {'Content-Type': 'application/json'};    
    final body = jsonEncode(data);


    final resp = await http.post(Uri.parse('${ Environment.apiUrl }/logindriver'), body: body, headers: headers  );      
    
    if ( resp.statusCode == 200 ) {

      final loginResponse = loginResponseFromJson( resp.body );

      final usuario = loginResponse.usuario as Usuario;      
      
      
      final privateToken = loginResponse.token; 
     
      await  storage.saveToken(privateToken);    
      await  storage.saveId(usuario.id);
      await  storage.saveNameDriver(usuario.nombre);

         
      return loginResponse;
    } else {     
             final response =  LoginResponse(
             ok: false,
             usuario: null,
             token: '');

       return response;
      }

    }
      
}