import 'dart:async';
import 'package:equatable/equatable.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:inri_driver/models/address.dart';

import 'package:inri_driver/service/addresses_service.dart';
import 'package:inri_driver/service/location_service.dart';
import 'package:inri_driver/service/storage_service.dart';


part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends HydratedBloc<AddressEvent, AddressState> {
  
  final AuthBloc authBloc;
  final CronometroBloc cronometroBloc;
  AddressService addressService;
  Timer? _pollingTimer;
  final storage = StorageService.instance;
  

  final StreamController<Address> _addressController = StreamController();
  Stream get  addressOrder => _addressController.stream;

  AddressBloc({required this.addressService, required this.authBloc, required this.cronometroBloc}) : super( const AddressState()) {

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
  on<OnCancelTravel>(_initCancelTravel);
  // conductor finaliza viaje
  on<FinishOrderEvent>(_onFinishOrderEvent);

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
  void _acceptTravel(OnAcceptedTravel event, Emitter<AddressState> emit) async {
  final currentAddress = state.address;
  
  if (currentAddress != null) {
    // 🔵 Actualizamos el Address local inmediatamente
    final updatedAddress = currentAddress.copyWith(
      order: 'en-camino',
      idDriver: currentAddress.idDriver,
    );
    emit(state.copyWith(address: updatedAddress));

    // 🔵 Después hacemos la llamada al backend
    await addressService.updateEnCamino(currentAddress);
  }
}



 //cancelar viaje
  void _initCancelTravel(OnCancelTravel event, Emitter<AddressState> emit) async {
     final result = await _driverCancelTravel();
  if (result) {
    add(const OnClearStateEvent()); // ← importante para reiniciar correctamente la UI
  }
  }

  
  Future<bool> _driverCancelTravel () async{ 

   final address = state.address;
   if (address == null) return false;

   final result = await addressService.cancelTravel(state.address!);   
   if (result is Map<String, dynamic>) {
     return true;
   } else {
     return false;
   }   
 }

  Future<void> _onFinishOrderEvent(
  FinishOrderEvent event,
  Emitter<AddressState> emit,
) async {
  

  final  token = await storage.getTokenUser();
  final idDriver = authBloc.state.usuario?.id;

  final precioPorEspera = cronometroBloc.state.price; 

 
  final precioPorDistancia = state.address?.precio ?? 0.0;
  final precioTotal = precioPorDistancia + precioPorEspera;

  if (state.address != null) {
   // Si necesitás guardarlo en el bloc:
  emit(state.copyWith(address: state.address?.copyWith(precio: precioTotal)));
  } 

  
  if (token == null || idDriver == null) {   
   return;
  }
   
   try {
    
    
    await addressService.finishTravel(token, idDriver, precioTotal);   

    //await StorageService.instance.deleteIdDriver();
    await StorageService.instance.deleteIdOrder();   
   

    add(const OnClearStateEvent());  

    emit(state.copyWith(message: 'viaje_finalizado'));
    
  } catch (e) {
    emit(state.copyWith(message: 'error_finalizar'));
  }
}


  

  // Guarda una Address dentro de un evento tipo Address
  Future<void> getOrder() async{

  final idUser = authBloc.state.usuario?.id;
  await storage.getIdOrder() != null;
  
  if ( idUser == null) return;   
  
  try {
   

    final respOrder = await addressService.getAddresses();
    
    final id = respOrder.idDriver;
    
    if (id == '0') {
     
      add(const OnClearStateEvent());
      return;
    } else {
      final current = state.address;
     
      final hasChanged = current == null ||
                         current.id != respOrder.id ||
                         current.order != respOrder.order ||
                         current.horaEsperaInicio != respOrder.horaEsperaInicio ||
                         current.horaEsperaFin != respOrder.horaEsperaFin;

      if (hasChanged) {
               
        add(AddAddressEvent(respOrder));
      } else {
       return;
      }

      LocationService.instance.saveOrderUser(respOrder);
    
    }
  } catch (_) {
    return;
  }
}



  
  
  
  void startLoadingAddress() {
  add(OnStartLoadingAddress()); 
  
}


  void stopLoadingAddress(){    
  _pollingTimer?.cancel();
  _pollingTimer = null;
   
  }


   // 🚀 Nuevo: empezar polling automático
  void startPollingOrder() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await getOrder();
        
      
    });
  }

  // 🚀 Nuevo: detener polling automático
  void stopPollingOrder() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }


  @override
  Future<void> close() {
    stopLoadingAddress();
    stopPollingOrder();
    return super.close();
  }

}
