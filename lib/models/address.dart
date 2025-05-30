// To parse this JSON data, do
//
//     final addressResp = addressRespFromMap(jsonString);

class Address {
  bool? ok;
  String? msg;
  String? id;
  String? nombre;
  String? email;
  bool? online;
  bool? estado;
  List<double>? ubicacion;
  List<double>? destino; // 🆕 nuevo campo
  DateTime? createdAt;
  DateTime? updatedAt;
  String? idDriver;
  Map<String, dynamic>? cupon;
  double? distanciaKm;
  double? precio;
  DateTime? horaEsperaInicio;
  DateTime? horaEsperaFin;
  String? order;
  bool? finalizado; 

  Address({
    this.ok,
    this.msg,
    this.id,
    this.nombre,
    this.email,
    this.online,
    this.estado,
    this.ubicacion,
    this.destino, // 🆕 nuevo campo
    this.createdAt,
    this.updatedAt,
    this.idDriver,
    this.cupon,
    this.distanciaKm,
    this.precio,
    this.horaEsperaInicio,
    this.horaEsperaFin,
    this.order,
    this.finalizado,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      ok: json["ok"] ?? false,
      msg: json["msg"] ?? '',
      id: json["_id"] ?? '',
      nombre: json["nombre"] ?? '',
      email: json["email"] ?? '',
      online: json["online"] ?? false,
      estado: json["estado"] ?? false,
      cupon: (json["cupon"] != null && json["cupon"] is Map)
      ? Map<String, dynamic>.from(json["cupon"])
      : null,
      ubicacion: json["ubicacion"] == null
      ? null
      : List<double>.from(json["ubicacion"]["coordinates"].map((x) => x.toDouble())),
      destino: json["destino"] == null
      ? null
      : List<double>.from(json["destino"]["coordinates"].map((x) => x.toDouble())), // 🆕 nuevo
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      idDriver: json["idDriver"] ?? '',
      distanciaKm: (json["distanciaKm"] as num?)?.toDouble(),
      precio: (json["precio"] as num?)?.toDouble(),
      horaEsperaInicio: json["horaEsperaInicio"] == null ? null : DateTime.parse(json["horaEsperaInicio"]),
      horaEsperaFin: json["horaEsperaFin"] == null ? null : DateTime.parse(json["horaEsperaFin"]),
      order: json["order"] ?? '',
      finalizado: json["finalizado"] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "msg": msg,
        "_id": id,
        "nombre": nombre,
        "email": email,
        "online": online,
        "estado": estado,
        "cupon": cupon,
        "ubicacion": ubicacion == null
            ? null
            : List<dynamic>.from(ubicacion!.map((x) => x)),
        "destino": destino == null
            ? null
            : List<dynamic>.from(destino!.map((x) => x)), // 🆕 nuevo
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "idDriver": idDriver,
        "distanciaKm": distanciaKm,
        "precio": precio,
        "horaEsperaInicio": horaEsperaInicio?.toIso8601String(),
        "horaEsperaFin": horaEsperaFin?.toIso8601String(),
        "order": order,
        "finalizado": finalizado,
      };

  Map<String, dynamic> toJson() => toMap();

  Address copyWith({
    bool? ok,
    String? msg,
    String? id,
    String? nombre,
    String? email,
    bool? online,
    bool? estado,
    List<double>? ubicacion,
    List<double>? destino, // 🆕 nuevo
    DateTime? createdAt,
    DateTime? updatedAt,
    String? idDriver,
    Map<String, dynamic>? cupon,
    double? distanciaKm,
    double? precio,
    DateTime? horaEsperaInicio,
    DateTime? horaEsperaFin,
    String? order,
    bool? finalizado,
  }) {
    return Address(
      ok: ok ?? this.ok,
      msg: msg ?? this.msg,
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      online: online ?? this.online,
      estado: estado ?? this.estado,
      ubicacion: ubicacion ?? this.ubicacion,
      destino: destino ?? this.destino, // 🆕 nuevo
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      idDriver: idDriver ?? this.idDriver,
      cupon: cupon ?? this.cupon,
      distanciaKm: distanciaKm ?? this.distanciaKm,
      precio: precio ?? this.precio,
      horaEsperaInicio: horaEsperaInicio ?? this.horaEsperaInicio,
      horaEsperaFin: horaEsperaFin ?? this.horaEsperaFin,
      order: order ?? this.order,
      finalizado: finalizado ?? this.finalizado,
    );
  }
}
