import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'cronometro_event.dart';
part 'cronometro_state.dart';

class CronometroBloc extends Bloc<CronometroEvent, CronometroState> {
  Timer? _timer;

  CronometroBloc() : super(const CronometroState()) {
    on<StartCronometroEvent>(_onStart);
    on<StopCronometroEvent>(_onStop);
    on<TickCronometroEvent>(_onTick);
    on<ResetCronometroEvent>(_onReset);
  }

  void _onStart(StartCronometroEvent event, Emitter<CronometroState> emit) {
    _timer?.cancel();
    final now = DateTime.now();
    final inicio = event.horaInicio;
    final durationSeconds = now.difference(inicio).inSeconds;

    emit(state.copyWith(
      duration: durationSeconds,
      price: 0.0,
      horaEsperaInicio: inicio,
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TickCronometroEvent());
    });
  }

  void _onStop(StopCronometroEvent event, Emitter<CronometroState> emit) {
    _timer?.cancel();
    emit(state.copyWith(
      duration: state.duration,
      price: state.price,
    ));
  }

  void _onTick(TickCronometroEvent event, Emitter<CronometroState> emit) {
    final newDuration = state.duration + 1;
    final price = _calcularPrecioPorMinuto(newDuration);
    emit(state.copyWith(duration: newDuration, price: price));
  }

  void _onReset(ResetCronometroEvent event, Emitter<CronometroState> emit) {
    _timer?.cancel();
    emit(const CronometroState());
  }

  double _calcularPrecioPorMinuto(int durationInSeconds) {
    final minutos = durationInSeconds / 60;
    return (minutos * 40).ceilToDouble(); // 💰 ejemplo: $40 por minuto
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

