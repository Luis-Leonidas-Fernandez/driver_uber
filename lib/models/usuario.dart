// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);


import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    Usuario({
        required this.email,
        required this.nombre,
        required this.apellido,
        required this.nacimiento,
        required this.domicilio,
        required this.vehiculo,
        required this.modelo,
        required this.patente,
        required this.licencia,
        required this.id,        
        required this.urlMapbox,
        required this.tokenMapBox,
        required this.idMapBox,
        required this.mapToken,
        this.base

    });

    String email;
    String nombre;
    String apellido;
    String nacimiento;
    String domicilio;
    String vehiculo;
    String modelo;
    String patente;
    String licencia;
    String id; 
    String urlMapbox;
    String tokenMapBox;
    String idMapBox;
    String mapToken;
    String? base;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        email: json["email"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        nacimiento: json["nacimiento"],
        domicilio: json["domicilio"],
        vehiculo: json["vehiculo"],
        modelo: json["modelo"],
        patente: json["patente"],
        licencia: json["licencia"],
        id: json["_id"]?? [''],  
        urlMapbox: json["urlMapbox"],
        tokenMapBox: json["tokenMapBox"],
        idMapBox: json["idMapBox"],
        mapToken: json["mapToken"],
        base: json["base"] ?? ""
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "nombre": nombre,
        "apellido": apellido,
        "nacimiento": nacimiento,
        "domicilio": domicilio,
        "vehiculo": vehiculo,
        "modelo": modelo,
        "patente": patente,
        "licencia": licencia,
        "id": id,        
        "urlMapbox": urlMapbox,
        "tokenMapBox": tokenMapBox,
        "idMapBox": idMapBox,
        "mapToken": mapToken,
        "base": base,

    };

  Usuario copyWith({
  String? email,
  String? nombre,
  String? apellido,
  String? nacimiento,
  String? domicilio,
  String? vehiculo,
  String? modelo,
  String? patente,
  String? licencia,
  String? id,
  String? urlMapbox,
  String? tokenMapBox,
  String? idMapBox,
  String? mapToken,
  String? base,
}) {
  return Usuario(
    email: email ?? this.email,
    nombre: nombre ?? this.nombre,
    apellido: apellido ?? this.apellido,
    nacimiento: nacimiento ?? this.nacimiento,
    domicilio: domicilio ?? this.domicilio,
    vehiculo: vehiculo ?? this.vehiculo,
    modelo: modelo ?? this.modelo,
    patente: patente ?? this.patente,
    licencia: licencia ?? this.licencia,
    id: id ?? this.id,
    urlMapbox: urlMapbox ?? this.urlMapbox,
    tokenMapBox: tokenMapBox ?? this.tokenMapBox,
    idMapBox: idMapBox ?? this.idMapBox,
    mapToken: mapToken ?? this.mapToken,
    base: base ?? this.base,
  );
}
  
}
