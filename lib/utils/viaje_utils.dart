import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:inri_driver/blocs/base/base_bloc.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:inri_driver/service/socket_service.dart';
import 'package:inri_driver/service/storage_service.dart';




class ViajeUtils {
  /// Función maestra para limpiar todo al finalizar un viaje
  static Future<void> finishTravelandClearAll(BuildContext context) async { 
    
  
    // 1. Cancelar sockets y streams antes de todo
  SocketService.instance.finishSocket(); 
  context.read<LocationBloc>().stopFollowingUser();
  context.read<LocationBloc>().stopPeriodicTask();
  context.read<AddressBloc>().stopLoadingAddress();

  // 2. Borrar token ANTES de borrar storage HydratedBloc
  await StorageService.instance.storage.delete(key: 'token');
  await StorageService.instance.deleteIdOrder();
  await Future.delayed(const Duration(milliseconds: 300));
  
  if (!context.mounted) return;

  // 3. Reiniciar lógica de precio y cronómetro
  context.read<PrecioDistanciaBloc>().add(const ResetearPrecioDistanciaEvent());
  context.read<CronometroBloc>().add(const ResetCronometroEvent());

  // 4. Reiniciar estados de blocs
  context.read<AddressBloc>().add(OnCancelTravel());
  context.read<AuthBloc>().add(const OnClearUserSessionEvent());
  context.read<BaseBloc>().add(ClearBaseEvent());

  // 5. Ahora sí, limpia todo lo persistido
  await HydratedBloc.storage.clear();
    
      

   
  }
}
