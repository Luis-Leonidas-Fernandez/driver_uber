part of 'tarifario_bloc.dart';


sealed class TarifarioEvent extends Equatable {
  const TarifarioEvent();

  @override
  List<Object> get props => [];
}
class InitTarifarioEvent extends TarifarioEvent {
  final List<Tarifa> tarifas;

  const InitTarifarioEvent(this.tarifas);

  @override
  List<Object> get props => [tarifas];
}

