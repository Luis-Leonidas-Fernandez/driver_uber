import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:inri_driver/models/tarifa.dart';

class TarifarioLoader {
  static Future<List<Tarifa>> cargarDesdeAssets() async {
    final jsonString = await rootBundle.loadString('assets/tarifas.json');
    final List<dynamic> data = jsonDecode(jsonString);
    return data.map((e) => Tarifa.fromJson(e)).toList();
  }
}
