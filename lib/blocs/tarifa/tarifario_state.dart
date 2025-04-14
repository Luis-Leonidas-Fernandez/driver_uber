part of 'tarifario_bloc.dart';

sealed class TarifarioState extends Equatable {
  const TarifarioState();
  
  @override
  List<Object> get props => [];
}

final class TarifarioInitial extends TarifarioState {
  const TarifarioInitial();
}

final class TarifarioLoaded extends TarifarioState {
  final List<Tarifa> tarifas;
  const TarifarioLoaded(this.tarifas);

  @override
  List<Object> get props => [tarifas];
}

