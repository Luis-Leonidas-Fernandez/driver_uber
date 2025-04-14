part of 'cronometro_bloc.dart';

class CronometroState extends Equatable {
  final int duration;
  final double price;
  final DateTime? horaEsperaInicio;
  final DateTime? horaEsperaFin;

  const CronometroState({
    this.duration = 0,
    this.price = 0.0,
    this.horaEsperaInicio,
    this.horaEsperaFin,
  });

  CronometroState copyWith({
    int? duration,
    double? price,
    DateTime? horaEsperaInicio,
    DateTime? horaEsperaFin,
  }) {
    return CronometroState(
      duration: duration ?? this.duration,
      price: price ?? this.price,
      horaEsperaInicio: horaEsperaInicio ?? this.horaEsperaInicio,
      horaEsperaFin: horaEsperaFin ?? this.horaEsperaFin,
    );
  }

  @override
  List<Object?> get props => [duration, price, horaEsperaInicio, horaEsperaFin];

  String get formattedDuration {
    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

