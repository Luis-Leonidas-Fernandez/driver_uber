part of 'precio_distancia_bloc.dart';

abstract class PrecioDistanciaEvent extends Equatable {
  const PrecioDistanciaEvent();

  @override
  List<Object?> get props => [];
}

class ActualizarUbicacionEvent extends PrecioDistanciaEvent {
  final LatLng ubicacion;

  const ActualizarUbicacionEvent({required this.ubicacion});

  @override
  List<Object> get props => [ubicacion];
}

class ResetearPrecioDistanciaEvent extends PrecioDistanciaEvent {
  const ResetearPrecioDistanciaEvent();
}

class IniciarCalculoPrecioEvent extends PrecioDistanciaEvent {
  const IniciarCalculoPrecioEvent();
}

class DetenerCalculoPrecioEvent extends PrecioDistanciaEvent {
  const DetenerCalculoPrecioEvent();
}

