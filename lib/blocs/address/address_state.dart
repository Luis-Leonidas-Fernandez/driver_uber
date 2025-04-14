part of 'address_bloc.dart';


class AddressState extends Equatable {  

final bool loading;
final bool existOrder; 
final Address? address;
final List<Address> addressHistory;
final bool isAccepted;
final bool isPressed;
final DateTime? horaEsperaFin;



const AddressState({
  this.loading = false,
  this.existOrder = false,
  this.isPressed = false,  
  this.address,
  this.isAccepted = false,
  this.horaEsperaFin,  
  addressHistory   

}): addressHistory = addressHistory ?? const[];

AddressState copyWith({
  bool? loading,
  bool? existOrder,  
  Address? address,
  bool? isAccepted,
  bool? isPressed, 
  List<Address>? addresshistory,
  DateTime? horaEsperaFin,
})
=> AddressState(
  loading: loading?? this.loading,
  existOrder: existOrder?? this.existOrder, 
  address: address?? this.address,
  isAccepted: isAccepted?? this.isAccepted,
  isPressed: isPressed?? this.isPressed,  
  addressHistory: addresshistory?? addressHistory,
  horaEsperaFin: horaEsperaFin ?? this.horaEsperaFin,
);

  
  @override
  List<Object?> get props => [loading, existOrder,  isAccepted, isPressed, address, addressHistory, horaEsperaFin,];
}

class UserInitialState extends AddressState {
  const UserInitialState(): super( existOrder: false, address: null, isPressed: false, horaEsperaFin: null);
}


