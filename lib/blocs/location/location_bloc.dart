

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inri_driver/blocs/address/address_bloc.dart';

import 'package:inri_driver/service/socket_service.dart';
import 'package:inri_driver/service/storage_service.dart';
import 'package:latlong2/latlong.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {

  final AddressBloc addressBloc;
  StreamSubscription<Position>? positionStream;
  Timer? timer;
 
  LocationBloc({required this.addressBloc}) : super(const LocationState()) {

    on<OnStartFollowingUser>((event, emit) => emit(state.copyWith(followingUser: true)));
    on<OnStopFollowingUser>((event, emit) => emit(state.copyWith(followingUser: false)));

    on<OnNewUserLocationEvent>((event, emit) {
      emit(state.copyWith(
          lastKnownLocation: event.newLocation,
          myLocationHistory: [...state.myLocationHistory, event.newLocation]));
    });
  }

  Future getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  

    add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
  }

  void startFollowingUser() async {

    
    // FollowingUser = true;
    add(OnStartFollowingUser());

    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;

      //Agrega la ubicacion del usuario a un evento
      add(OnNewUserLocationEvent(
          LatLng(position.latitude, position.longitude)));
    });
  }

  

  void sendPeriodicPosition() {

    if (timer != null && timer!.isActive) {
    
    return; // Ya hay un Timer corriendo
  }

 

       
    timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      
         final position = state.lastKnownLocation;

         if (position == null) {
      
         return;
         }

       
         // 🚨 NUEVO: Consultamos AddressBloc directamente
         final address = addressBloc.state.address;
        
         final isAccepted = addressBloc.state.isAccepted;
         final viajeEnCurso = address?.finalizado == false;


         final hasValidOrder = address != null && address.id != null && address.id!.isNotEmpty;
         final hasDriverAssigned = address?.idDriver != null && address!.idDriver!.isNotEmpty;

         if (!(hasValidOrder && hasDriverAssigned && isAccepted && viajeEnCurso)) {
         
         this.timer?.cancel();
         this.timer = null;
         return;
        }
        
          
         sendLocationDriver(position);
         
        
      //}
    });
  }

  Future<void> sendLocationDriver(LatLng position) async {

    final socket = SocketService.instance.socket;

    final location = position;
    final data = LatLng(location.latitude, location.longitude);

   
    final idUser = await StorageService.instance.getId();
    final idOrder = await StorageService.instance.getIdOrder();
    
    await Future.delayed(const Duration(seconds: 2));

    socket!.emit('driver-location',
        {
          'mensaje': data,
          'idDriver': idUser,
          'idOrder': idOrder});
    await Future.delayed(const Duration(seconds: 2));
  

  }

  void stopPeriodicTask() {
    timer?.cancel();
    timer = null;    
   
  }

  void stopFollowingUser() {
    positionStream?.cancel();   
    add(OnStopFollowingUser());
  }

  @override
  Future<void> close() {
    SocketService.instance.finishSocket();
    stopFollowingUser();
    stopPeriodicTask();
    return super.close();
  }
}
