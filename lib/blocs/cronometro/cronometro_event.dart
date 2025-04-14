part of 'cronometro_bloc.dart';

abstract class CronometroEvent extends Equatable {
  const CronometroEvent();

  @override
  List<Object> get props => [];
}

class StartCronometroEvent extends CronometroEvent {
  final DateTime horaInicio;
  const StartCronometroEvent({required this.horaInicio});
  @override
  List<Object> get props => [horaInicio];
}

class StopCronometroEvent extends CronometroEvent {
  const StopCronometroEvent();
}

class ResetCronometroEvent extends CronometroEvent {
  const ResetCronometroEvent();
}

class TickCronometroEvent extends CronometroEvent {
  const TickCronometroEvent();
}
