import 'dart:convert';

import 'package:inri_driver/global/environment.dart';
import 'package:inri_driver/models/base.dart';
import 'package:inri_driver/models/bases_conductor.dart';
import 'package:inri_driver/service/storage_service.dart';
import 'package:http/http.dart' as http;

class BaseService {

  late BaseModel baseSelected;
  final storage = StorageService.instance;


  Future<bool> addDriverToBase(BaseModel? baseSelected) async {

    final token  = await StorageService.instance.getTokenUser();
    final idUser = await StorageService.instance.getId();    

    
    final zona = baseSelected?.zona ?? "";
    final base = baseSelected?.base ?? "";
    final Map<String, String> data = {'zona': zona, 'base': base};
   


    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token.toString()
    };
    

    final resp = await http.put(Uri.parse('${Environment.apiUrl}/base/add-driver-to-base/$idUser'),
    headers: headers, body: json.encode(data));
    
    if (resp.statusCode == 200) {
     
      return true;
    } else {
      return false;
    }
  }


  Future<List<BaseConductor>> getBases() async {

    final token = await storage.getTokenUser();
    
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token.toString()
    };

    final response = await http.get(Uri.parse('${Environment.apiUrl}/base/all'), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['ok'] == true && data['bases'] != null) {
        final List basesJson = data['bases'];
        return basesJson.map((e) => BaseConductor.fromJson(e)).toList();
      } else {
        throw Exception('Respuesta inválida del servidor');
      }
    } else {
      throw Exception('Error al obtener bases: ${response.statusCode}');
    }
  }
  












}