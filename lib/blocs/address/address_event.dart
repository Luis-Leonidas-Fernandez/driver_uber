part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class AddAddressEvent extends AddressEvent{

  final Address address;  
  const AddAddressEvent(this.address);

}



class OnClearStateEvent extends AddressEvent{
  
  const OnClearStateEvent();

}

class ExistOrderUserEvent extends AddressEvent{}
class OnNotExistOrderUserEvent extends AddressEvent{}
class OnStartLoadingAddress extends AddressEvent{}
class OnStopLoadingAddress extends AddressEvent{}
class OnIsAcceptedTravel extends AddressEvent{}
class OnIsDeclinedTravel extends AddressEvent{}
class OnLockBtnArriveEvent extends AddressEvent{}


//class OnArriveDriverEvent extends AddressEvent{}


//conductor en camino
class OnAcceptedTravel extends AddressEvent{}
//conductor cancela viaje
class OnCancelTravel extends AddressEvent{}
// conductor finaliza viaje
class FinishOrderEvent extends AddressEvent {

  final double precioDistancia;
  final double precioPorEspera;

  const FinishOrderEvent({
    required this.precioDistancia,
    required this.precioPorEspera,
  });

  @override
  List<Object?> get props => [precioDistancia, precioPorEspera];
}



// Conductor hace tap en cronometro parando el tiempo y mostrando la tarifa final
class OnGuardarHoraEsperaFin extends AddressEvent {
  final DateTime horaEsperaFin;

  const OnGuardarHoraEsperaFin(this.horaEsperaFin);

  @override
  List<Object?> get props => [horaEsperaFin];
}




