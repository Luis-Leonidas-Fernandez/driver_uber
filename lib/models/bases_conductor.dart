

import 'package:latlong2/latlong.dart';

class BaseConductor {
  final String? id;
  final int? base;
  final String? adminId;
  final String? zonaName;
  final List<String>? idDriver;
  final int? viajes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final LatLng? ubicacion;

  BaseConductor({
    this.id,
    this.base,
    this.adminId,
    this.zonaName,
    this.idDriver,
    this.viajes,
    this.createdAt,
    this.updatedAt,
    this.ubicacion,
  });

  factory BaseConductor.fromJson(Map<String, dynamic> json) {
  try {
    final coords = json['ubicacion']?['coordinates'];
    final latLng = (coords != null && coords.length == 2)
        ? LatLng(coords[1], coords[0])
        : null;

    if (latLng == null) {
    
    }

    return BaseConductor(
      id: json['_id'],
      base: json['base'],
      adminId: json['adminId'],
      zonaName: json['zonaName'],
      idDriver: (json['idDriver'] as List?)?.map((e) => e.toString()).toList(),
      viajes: json['viajes'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      ubicacion: latLng,
    );
  } catch (e) {
   
    return BaseConductor(); // Retorna instancia vacía si falla
  }
}


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'base': base,
      'adminId': adminId,
      'zonaName': zonaName,
      'idDriver': idDriver,
      'viajes': viajes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'ubicacion': ubicacion != null
          ? {
              'type': 'Point',
              'coordinates': [ubicacion!.longitude, ubicacion!.latitude],
            }
          : null,
    };
  }

  BaseConductor copyWith({
    String? id,
    int? base,
    String? adminId,
    String? zonaName,
    List<String>? idDriver,
    int? viajes,
    DateTime? createdAt,
    DateTime? updatedAt,
    LatLng? ubicacion,
  }) {
    return BaseConductor(
      id: id ?? this.id,
      base: base ?? this.base,
      adminId: adminId ?? this.adminId,
      zonaName: zonaName ?? this.zonaName,
      idDriver: idDriver ?? this.idDriver,
      viajes: viajes ?? this.viajes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ubicacion: ubicacion ?? this.ubicacion,
    );
  }
}
