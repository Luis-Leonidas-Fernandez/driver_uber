part of 'base_bloc.dart';

abstract class BaseEvent extends Equatable {

  const BaseEvent();

  @override
  List<Object> get props => [];
}

class AddBaseEvent extends BaseEvent{

  final BaseModel baseSelected;  
  const AddBaseEvent(this.baseSelected);

}

class SetBasesDisponiblesEvent extends BaseEvent {
  final List<BaseConductor> basesDisponibles;
  const SetBasesDisponiblesEvent(this.basesDisponibles);

  @override
  List<Object> get props => [basesDisponibles];
}

class ClearBaseEvent extends BaseEvent {}
