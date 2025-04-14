// ignore_for_file: avoid_print
import 'dart:async';
import 'package:equatable/equatable.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:inri_driver/models/address.dart';

import 'package:inri_driver/service/addresses_service.dart';
import 'package:inri_driver/service/location_service.dart';


part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends HydratedBloc<AddressEvent, AddressState> {
  
  final AuthBloc authBloc;
  AddressService addressService;
  //Address? address;
  //StreamSubscription<List<Address>>? addressStream;
  

  final StreamController<Address> _addressController = StreamController();
  Stream get  addressOrder => _addressController.stream;

  AddressBloc({required this.addressService, required this.authBloc}) : super( const AddressState()) {

  on<OnStartLoadingAddress>((event, emit) => emit(state.copyWith(loading: true)));
  on<OnStopLoadingAddress> ((event, emit)  => emit(state.copyWith(loading: false)));
  on<ExistOrderUserEvent>((event, emit)  => emit(state.copyWith(existOrder: true)));
  on<OnNotExistOrderUserEvent>((event, emit) => emit(state.copyWith(existOrder: false)));

  on<OnIsAcceptedTravel>((event, emit) => emit(state.copyWith(isAccepted: true, isPressed: true)));
  on<OnIsDeclinedTravel>((event, emit) => emit(state.copyWith(isAccepted: false)));
  on<OnClearStateEvent> ((event, emit)  => emit(const UserInitialState()));    
  on<OnLockBtnArriveEvent>((event, emit) => emit(state.copyWith(isPressed: false)));
  //conductor acepta viaje
  on<OnAcceptedTravel>(_acceptTravel);
  //conductor cancela viaje
  on<OnCancelTravel>(_cancelTravel);

  on<AddAddressEvent>((event, emit) {

      emit(state.copyWith(
        address: event.address,
        existOrder: true,        
        addresshistory: [...state.addressHistory, event.address]
      
      ));
      
    });

    // finaliza cronometro y actualiza hora espera fin backend
    on<OnGuardarHoraEsperaFin>((event, emit) async {
    final address = state.address;    

    if (address == null) return;  
    // Llamada al servicio para actualizar la hora de espera fin
    final updated = await addressService.updateHoraEsperaFin(address.id!, event.horaEsperaFin);   

    if (updated) {    
    // Emitir nuevo estado con hora actualizada
    final nuevaAddress = address.copyWith(horaEsperaFin: event.horaEsperaFin);
    emit(state.copyWith(address: nuevaAddress));
  }
});


    
    
  }

    @override
  Map<String, dynamic>? toJson(AddressState state) {

    if (state.address != null) {

      final data = state.address!.toJson();
     
      return data;
    }
    return null;

  }

  @override
  AddressState? fromJson(Map<String, dynamic> json) {
      

      try {
        
       final order = Address.fromJson(json);

       final obj = AddressState(
       address:  order,
       existOrder: order.id != null? true : false,       
       addressHistory: [...state.addressHistory, order] );      
               
       return obj;  

        
      } catch (e) {
        return null;
      }       
     
  } 
  
  //aceptar viaje
  void _acceptTravel(OnAcceptedTravel event, Emitter<AddressState> emit){
      _driverOnWay();
  }

  
  Future<bool> _driverOnWay () async{   
   final result = await addressService.updateEnCamino(state.address!);   
   if (result is Map<String, dynamic>) {
     return true;
   } else {
     return false;
   }   
 }


 //cancelar viaje
  void _cancelTravel(OnCancelTravel event, Emitter<AddressState> emit) async {
     final result = await _driverCancelTravel();
  if (result) {
    add(const OnClearStateEvent()); // ← importante para reiniciar correctamente la UI
  }
  }

  
  Future<bool> _driverCancelTravel () async{ 

   final address = state.address;
   if (address == null) return false;

   final result = await addressService.finishTravel(state.address!);   
   if (result is Map<String, dynamic>) {
     return true;
   } else {
     return false;
   }   
 }



  

  // Guarda una Address dentro de un evento tipo Address
  Stream<Address> getOrder() async* { 

    final closeController = _addressController.isClosed;

    try {

      if (closeController) return;

      // getAddresses recibe [TOKEN] desde el storage
    final respOrder = await addressService.getAddresses();       
    final id =respOrder.idDriver;    

    if(id == '0'){       
       add(const OnClearStateEvent());      
      return;

    }else{     
     
      add(AddAddressEvent(respOrder));
      
     _addressController.add(respOrder);

     LocationService.instance.saveOrderUser(respOrder);

      yield respOrder;
     
    }      

    } catch (e) {      
      print('Error: $e');
    }
     
    
    

  } 

  
  
  
  void startLoadingAddress(){ 

    add(OnStartLoadingAddress());  
    getOrder;
   
  } 

  void stopLoadingAddress(){    
    _addressController.close;
    add(OnStopLoadingAddress());
   
  }


  @override
  Future<void> close() {
    stopLoadingAddress();
    return super.close();
  }

}
