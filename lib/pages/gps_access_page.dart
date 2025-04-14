import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_driver/blocs/gps/gps_bloc.dart';
import 'package:inri_driver/service/background_service.dart';

class GpsAccessPage extends StatelessWidget {
  const GpsAccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) { 

           final gpsEnabled = state.gpsModel?.isGpsEnabled?? false;
           print('gpsacces page gps enable: $gpsEnabled');

           return gpsEnabled == false
           ? const _EnableGpsMessage()
           : const _AccessButton(); 
          }
          )
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Text('Es necesario el acceso al GPS'),
       MaterialButton(
        color: Colors.black,
        shape: const StadiumBorder(),
        elevation: 0,
        onPressed: () async{
          //solicita privilegios de ubicacion
          final gpsBloc = BlocProvider.of<GpsBloc>(context);
          gpsBloc.askGpsAccess();
          
          final gps = gpsBloc.state.gpsModel;
          
          if (gps != null && gps.isGpsEnabled == true && gps.isGpsPermissionGranted == true) {
          await BackgroundService.instance.initializeService(); // ✅ Inicia servicio
         }
        },
        child:  const Text('Solicitar Acceso',
        style:  TextStyle(color: Colors.white ))
        )
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Debe habilitar el Gps',
    style: TextStyle(
      fontSize: 23, fontWeight: FontWeight.w600
    ),
    );
  }
}