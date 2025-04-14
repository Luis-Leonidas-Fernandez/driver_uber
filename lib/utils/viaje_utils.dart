import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:inri_driver/service/socket_service.dart';


class ViajeUtils {
  /// Función maestra para limpiar todo al finalizar un viaje
  static Future<void> finishTravelandClearAll(BuildContext context) async {  

    // 1. Cancelar streams, timers y ubicaciones
    context.read<LocationBloc>().stopFollowingUser();
    context.read<LocationBloc>().stopPeriodicTask();

    // 2. Reiniciar lógica de precio y cronómetro
    context.read<PrecioDistanciaBloc>().add(const ResetearPrecioDistanciaEvent());
    context.read<CronometroBloc>().add(const ResetCronometroEvent());

    // 3. Reiniciar estado de AddressBloc
    context.read<AddressBloc>().add(OnCancelTravel());    

    SocketService.instance.socket?.close();   

   
  }
}
