import 'dart:async';
import 'package:equatable/equatable.dart';
//import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:inri_driver/models/gps.dart';
import 'package:permission_handler/permission_handler.dart';


part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends HydratedBloc<GpsEvent, GpsState> {

  late StreamSubscription gpsServiceSubscription;
  
GpsBloc() : super(const GpsState(gpsModel: null)) {
    
    //emite evento comunicando si el Gps esta Activo y tambien si los permisos estan habilitados
    on<GpsAndPermissionEvent>((event, emit) => emit(state.copyWith(
      gpsModel: event.gpsModel
    ))
    );
    init();
  }


  @override
  GpsState? fromJson(Map<String, dynamic> json) {
    

    try {

      final gpsModel  = GpsModel.fromJson(json);
            
      final gpsStatus = GpsState(
      gpsModel: gpsModel,      
       );
            
      
      return gpsStatus;  

      
    } catch (e) {
      return null;
    }
       
  }  

  @override
  Map<String, dynamic>? toJson(GpsState state) {
    
     if(state.gpsModel != null){
      final data = state.gpsModel!.toJson();      
     
      return data;
     }else{
      return null;
     }     

  } 


  Future <void> init() async {

    await _checkGpsStatus();
    
    
    final gpsInitStatus = await Future.wait([
    _checkGpsStatus(),
    _isPermissionGranted(),
    ]);
    

    final gpsStatus = GpsModel(
      isGpsEnabled: gpsInitStatus[0],
      isGpsPermissionGranted: gpsInitStatus[1]); 

    add(GpsAndPermissionEvent(
      gpsModel: gpsStatus));



  }


  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;

  }



  Future <bool> _checkGpsStatus() async {

    //Analiza si los permisos del Gps estan habilitados  
    final isEnable = await Geolocator.isLocationServiceEnabled();
    
    gpsServiceSubscription = Geolocator.getServiceStatusStream().listen((event) {
    
    final isEnabled = (event.index == 1) ? true : false;


      add(GpsAndPermissionEvent(
        gpsModel: GpsModel(
          isGpsEnabled: isEnabled,
          isGpsPermissionGranted: state.gpsModel?.isGpsPermissionGranted  ?? false)
          ));
    });


    return isEnable;

  }





  //pregunta y muestra los permisos que necesita como la ubicacion
  Future<void> askGpsAccess() async {
  final status = await Permission.location.request();



  switch(status){

    case PermissionStatus.provisional:
    case PermissionStatus.granted:
      //habilita los permisos de la ubicacion
      add(GpsAndPermissionEvent(  

      gpsModel: GpsModel(
        isGpsEnabled: state.gpsModel!.isGpsEnabled,
        isGpsPermissionGranted: true)

      ));

      break;

    case PermissionStatus.denied:     
    case PermissionStatus.restricted:
    case PermissionStatus.limited:
    case PermissionStatus.permanentlyDenied:

   add(GpsAndPermissionEvent(
    
    gpsModel: GpsModel(
      isGpsEnabled: state.gpsModel!.isGpsEnabled,
      isGpsPermissionGranted: false)

    ));  
    openAppSettings(); 
    
      
  }

  }


  @override 
  Future<void> close(){
    gpsServiceSubscription.cancel();
    return super.close();
  } 

}
