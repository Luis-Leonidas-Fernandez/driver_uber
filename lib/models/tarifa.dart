class Tarifa {

  final double puntos;
  final int precio;

  Tarifa({

    required this.puntos,
    required this.precio,
  });

  factory Tarifa.fromJson(Map<String, dynamic> json) {
    return Tarifa(     
      puntos: (json['puntos'] as num).toDouble(),
      precio: (json['precio']as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'puntos': puntos,
      'precio': precio,
    };
  }
}
