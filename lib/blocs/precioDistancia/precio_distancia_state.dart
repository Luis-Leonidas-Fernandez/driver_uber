part of 'precio_distancia_bloc.dart';

class PrecioDistanciaState extends Equatable {
  final double precioActual;
  final double distanciaRecorrida;
  final LatLng? ultimaUbicacion;
  final bool calculando; 

  const PrecioDistanciaState({
    this.precioActual = 0.0,
    this.distanciaRecorrida = 0.0,
    this.ultimaUbicacion,
    this.calculando = false
  });

  PrecioDistanciaState copyWith({
    double? precioActual,
    double? distanciaRecorrida,
    LatLng? ultimaUbicacion,
    bool? calculando,
  }) {
    return PrecioDistanciaState(
      precioActual: precioActual ?? this.precioActual,
      distanciaRecorrida: distanciaRecorrida ?? this.distanciaRecorrida,
      ultimaUbicacion: ultimaUbicacion ?? this.ultimaUbicacion,
      calculando: calculando ?? this.calculando,
    );
  }

  @override
  List<Object?> get props => [precioActual, distanciaRecorrida, ultimaUbicacion, calculando];
}
