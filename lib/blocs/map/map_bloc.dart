// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:inri_driver/repositories/background_instance.dart';
import 'package:inri_driver/service/background_service.dart';
import 'package:latlong2/latlong.dart';
//import 'package:mapbox_gl/mapbox_gl.dart';


part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  final LocationBloc locationBloc;
  final AddressBloc addressBloc;
  
  //linea agregada
  final BackgroundInstance backgroundLocationRepository;
  
  //late MapboxMapController mapBoxController;
  //late MapboxMap mapBox;
  late MapController mapController; 

  StreamSubscription<LocationState>? locationStateSubscription;
  StreamSubscription<AddressState>? addressStateSubscription;

  MapBloc({
  required this.locationBloc,
  required this.addressBloc,
  //linea agregada
  required this.backgroundLocationRepository
  }) : super(const MapState()) {

    on<OnMapInitializeEvent>(_onInitMap  );
    on<OnStartFollowingUserEvent>(_onStartFollowingUser);    
    on<OnStopFollowingUserEvent>((event, emit) => emit( state.copyWith( isfollowingUser: false) ));
    on<OnAddAddressEvent>(_onAddAdress );
     
      
  
  locationStateSubscription = locationBloc.stream.listen((locationState){

    if(!state.isfollowingUser) return;
    if(locationState.lastKnownLocation ==null ) return;    
    //moveCamera(locationState.lastKnownLocation!);
    
  });

  addressStateSubscription = addressBloc.stream.listen((addressState) {

      if(addressState.address == null) return;
      addAddress(addressState.address!);
   }); 


  }

  void _onInitMap(OnMapInitializeEvent event, Emitter<MapState> emit){

    mapController = event.mapController;        
    emit(state.copyWith(isMapInitialized: true));
    
    
    
  }

  void _onStartFollowingUser(OnStartFollowingUserEvent event, Emitter<MapState> emit) {    
    emit( state.copyWith( isfollowingUser: true ) );
    //linea agregada
    backgroundLocationRepository.startForegroundService(); 
      
  }
 

  // se creo un evento el cual maneja las address
  void _onAddAdress(OnAddAddressEvent event, Emitter<MapState> emit) {    

    if( addressBloc.state.address == null ) return;
    addAddress(addressBloc.state.address!);
    
  }  
  
//se agrega la address a una funcion para dibujar la ui
  void addAddress( address){
    
  }

  void initBackgroundService() async {
    
    final service    =  FlutterBackgroundService();
    final isRunning  =  await service.isRunning();   
    

    if (isRunning ) {
      
      return;

    } else{

       await BackgroundService.instance.initializeService();
      
    }
      
     
    }


    LatLng bounds(List<double> location) {
      
    final LatLng driverPosition = locationBloc.state.lastKnownLocation ?? const LatLng(-27.452786, -58.985812);

    if( location.isEmpty) {
     final driverCenter  = LatLng(driverPosition.latitude - 0.015, driverPosition.longitude + 0.017);
    return driverCenter;
    }

    final user = List.from(location);
    
    final userPosition = LatLng(user[0], user[1]); 

    if(location.isEmpty) {
    final driverCenter  = LatLng(driverPosition.latitude - 0.015, driverPosition.longitude + 0.017);
    return driverCenter;
    }  
    

    final double left   = math.min(userPosition.latitude, driverPosition.latitude);
    final double right  = math.max(userPosition.latitude, driverPosition.latitude);
    final double top    = math.min(userPosition.longitude, driverPosition.longitude);
    final double bottom = math.max(userPosition.longitude, driverPosition.longitude);

    final LatLng southwest = LatLng(left,bottom);
    final LatLng northeast = LatLng(right, top);
    
    
     final LatLng  center = LatLng(
      (southwest.latitude + northeast.latitude) / 2 - 0.025,
      (southwest.longitude + northeast.longitude) / 2 + 0.025, 
      );    
   
   return center;
  }

  dynamic getZoom(List<double> location){
    
    if(addressBloc.state.address == null) return 6.0;

    final user = List.from(location);
    final LatLng driverPosition = locationBloc.state.lastKnownLocation!;
    final userPosition = LatLng(user[0], user[1]);    
    
    
    final distance = getDistanceInKM(userPosition, driverPosition);

    double radius = distance / 2;
    double scale  = radius / 0.3;
    final zoom    = (13 - math.log(scale) / math.log(2));
    
  
    
    if(distance <= 0.05){
      return 16.0;
    }else{
     return zoom;
    }

    




  }

  /// parse degrees to radians
  static double deg2rad(deg) {
    return deg * (math.pi / 180);
  }


   /// calculates the distance between two coords in km
  static double getDistanceInKM(LatLng userPosition, LatLng driverPosition) {
    final lat1 = userPosition.latitude;
    final lon1 = userPosition.longitude;
    final lat2 = driverPosition.latitude;
    final lon2 = driverPosition.longitude;

    const R = 6371; // Radius of the earth in km

    final dLat = deg2rad(lat2 - lat1); // deg2rad below
    final dLon = deg2rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final d = R * c; // Distance in km

    return d;
  }  
  
  

@override
  Future<void> close() {
    locationStateSubscription?.cancel();
    addressStateSubscription?.cancel();
    //linea agregada
    backgroundLocationRepository.stopForegroundService();
    return super.close();
  }  

}
