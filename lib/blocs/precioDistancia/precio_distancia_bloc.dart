import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inri_driver/models/tarifa.dart';
import 'package:latlong2/latlong.dart';

part 'precio_distancia_event.dart';
part 'precio_distancia_state.dart';

class PrecioDistanciaBloc extends Bloc<PrecioDistanciaEvent, PrecioDistanciaState> {
  final List<Tarifa> tarifas;
  final Distance _distance = const Distance();
  //bool _calculando = false;

  PrecioDistanciaBloc({required this.tarifas}) : super(const PrecioDistanciaState()) {

    on<ActualizarUbicacionEvent>(_onActualizarUbicacion);
    on<ResetearPrecioDistanciaEvent>(_onReset);

    on<IniciarCalculoPrecioEvent>((event, emit) {
   
    emit(state.copyWith(calculando: true));  
      
    });

    on<DetenerCalculoPrecioEvent>((event, emit) {
    emit(state.copyWith(calculando: false));    
    });


  }

  void _onActualizarUbicacion(ActualizarUbicacionEvent event, Emitter<PrecioDistanciaState> emit) {   

    if (!state.calculando) {  
     
    return;
    }

    if (state.ultimaUbicacion == null) {   
    emit(state.copyWith(ultimaUbicacion: event.ubicacion));
    return;
    }

    final double metros = _distance.as(
      LengthUnit.Meter,
      state.ultimaUbicacion!,
      event.ubicacion,
    );

    
    final double nuevaDistancia = state.distanciaRecorrida + metros;
    final double nuevoPrecio = _calcularPrecio(nuevaDistancia);

   
    emit(state.copyWith(
      ultimaUbicacion: event.ubicacion,
      distanciaRecorrida: nuevaDistancia,
      precioActual: nuevoPrecio,
    ));
  }

  void _onReset(ResetearPrecioDistanciaEvent event, Emitter<PrecioDistanciaState> emit) {   
   
    emit(const PrecioDistanciaState());
  }

  double _calcularPrecio(double distanciaMetros) {

    final km = distanciaMetros / 1000.0;
    Tarifa? tarifaCercana;
    double diferenciaMinima = double.infinity;

    for (final tarifa in tarifas) {
      final diferencia = (tarifa.puntos - km).abs();
      if (diferencia < diferenciaMinima) {
        diferenciaMinima = diferencia;
        tarifaCercana = tarifa;
      }
    }
    return tarifaCercana?.precio.toDouble() ?? 0.0;
  }

  
  
}
