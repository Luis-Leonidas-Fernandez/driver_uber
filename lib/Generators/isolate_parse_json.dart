

import 'dart:convert';
import 'dart:isolate';

import 'package:inri_driver/models/address.dart';
import 'package:inri_driver/service/storage_service.dart';

class ParseData{

    ParseData._internal();
    static final ParseData _instance = ParseData._internal();
    static ParseData get instance => _instance;
    final storage = StorageService.instance;
    Isolate? isolateResult;

    Future<Address> isolateFunction(String data) async{
   
   final resultPort = ReceivePort();

    try {
     

     isolateResult = await Isolate.spawn(
      readAndParseJson, [resultPort.sendPort, data],
      errorsAreFatal: true,
      onExit: resultPort.sendPort,
      onError: resultPort.sendPort,
      );     
     
       
     } on Object {       
      
       resultPort.close();
     } 
     
     final response =  await resultPort.first;
     return response;
    }
  

  Future<Address> readAndParseJson(List<dynamic> args) async {
    
    //convert data a Address Model 
    SendPort resultPort = args[0];
    String data = args[1];
    final newMap = {"id": null};

    final dataMap = jsonDecode(data)["address"]; 
    final Map<String, dynamic> response = dataMap ?? newMap; 
    final addressParsed  = Address.fromJson(response);
    
    await Future.delayed(const Duration(seconds: 3));
    
    Isolate.exit(resultPort, addressParsed); 
        
    
  }

  void stopIsolate(){
    isolateResult?.kill();
    isolateResult = null;
  }

}