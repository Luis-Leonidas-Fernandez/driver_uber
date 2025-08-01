

import 'dart:async';

import 'package:inri_driver/service/addresses_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:geolocator/geolocator.dart';
import 'package:inri_driver/service/storage_service.dart';

import 'package:latlong2/latlong.dart';

class LocationService {
  LocationService._internal();

  static final LocationService _instance = LocationService._internal();
  static LocationService get instance => _instance;

  bool _condition = false;

  bool get condition => _condition;

  set autenticando(bool valor) {
    _condition = valor;
  }

  // save position
  final userPosition = [];

  final myPosition = [];

  final List<dynamic> address = [];

  Future<bool> initFollowingBackground() async {
    
    final isPermisionLocation = await _isAccessDeviceGranted();

    try {

      if (isPermisionLocation) {

        const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 5) 
        );


        final position = await Geolocator.getCurrentPosition(
            locationSettings: locationSettings);

        final location = "${position.latitude} ${position.longitude}";
        final res = LatLng(position.latitude, position.longitude);

        myPosition.clear();
        userPosition.clear();

        // Position String
        userPosition.add(location);
        // Position LatLng
        myPosition.add(res);
   
        return true;
      }else{
        return false;
      }




    } catch (e) {
       return throw Exception('oops! $e');
    }
  }

  Future<bool> _isAccessDeviceGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  void saveOrderUser(order){

   address.add(order); 
   
  }

  Future<bool> isActiveOrder() async {
    final isActive = await StorageService.instance.getIdOrder();
    
    if(isActive == null ){
    return false;
    }
    return true;
  }

  Future<bool> getIdUserAndToken() async {
    final existToken = await StorageService.instance.getTokenUser();
    final existUser = await StorageService.instance.getId();
    
    if(existToken == null && existUser == null){
    return false;
    }
    return true;
  }

  Future<void> emitPositionBackground() async {
    
    final idOrder = await StorageService.instance.getIdOrder();
    final driverPosition = myPosition[0];

    Future.delayed(const Duration(seconds: 6));

  

    if (idOrder == null) {
      return;
    } else {
      AddressService().sendLocationBackground(driverPosition, idOrder);
    }
  }
}
