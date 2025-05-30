
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:inri_driver/constants/app_bar.dart';

import 'package:inri_driver/models/usuario.dart';
import 'package:inri_driver/views/views.dart';
import 'package:inri_driver/widgets/buttons/btn_arrived.dart';
import 'package:inri_driver/widgets/cards/booking_card.dart';
import 'package:inri_driver/widgets/widgets.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  AddressBloc? addressBloc;
  LocationBloc? locationBloc;
  AuthBloc? usuarioBloc;
  Usuario? usuario;

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addObserver(this);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();

    final addressBloc = BlocProvider.of<AddressBloc>(context);

    addressBloc.state.loading;
    addressBloc.startLoadingAddress();

    final mapBloc = BlocProvider.of<MapBloc>(context);
    mapBloc.initBackgroundService();

    addressBloc.startPollingOrder();

    BlocProvider.of<LocationBloc>(context);
    BlocProvider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    locationBloc?.stopFollowingUser();
    locationBloc?.stopPeriodicTask();
    addressBloc?.stopLoadingAddress();
    usuarioBloc?.deleteUser();
    addressBloc?.stopPollingOrder();
    super.dispose();
  }

   @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final locationBloc = context.read<LocationBloc>();

    if (state == AppLifecycleState.paused) {
     
      locationBloc.stopFollowingUser();
      locationBloc.stopPeriodicTask(); // deberías implementarla si aún no existe
    } else if (state == AppLifecycleState.resumed) {
     
      locationBloc.startFollowingUser();
      locationBloc.sendPeriodicPosition(); // solo si hay una orden activa
    }
  }


  @override
  Widget build(BuildContext context) {
    final usuarioBloc = BlocProvider.of<AuthBloc>(context);
    final addressBloc = BlocProvider.of<AddressBloc>(context);
    final nombre =  usuarioBloc.state.usuario?.nombre ?? '';

    return BlocListener<LocationBloc, LocationState>(
      listenWhen: (previous, current) =>
          previous.lastKnownLocation != current.lastKnownLocation,
      listener: (context, state) {
        final ubicacion = state.lastKnownLocation;
        final isCalculando =
            context.read<PrecioDistanciaBloc>().state.calculando;



        if (ubicacion != null && isCalculando) {
          context.read<PrecioDistanciaBloc>().add(
                ActualizarUbicacionEvent(ubicacion: ubicacion),
              );
          
        }
      },
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          final hasLocation = state.lastKnownLocation != null;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: hasLocation ? AppBarConstants.customAppBar(context, nombre) : null,
            body: Builder(
              builder: (context) {
                if (state.lastKnownLocation == null) return const ShimmerLoadingHome();
                final long = state.lastKnownLocation!.longitude;
                final lat = state.lastKnownLocation!.latitude;

                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      usuarioBloc.state.usuario != null
                          ? MapView(initialLocation: LatLng(lat, long))
                          : Container(),

                      // BlocListener para cambios de AddressBloc (aceptar viaje, empezar, etc)
                      BlocListener<AddressBloc, AddressState>(
                        listenWhen: (previous, current) =>
                            previous.address?.id != current.address?.id ||
                            previous.isAccepted != current.isAccepted ||
                            previous.address?.order != current.address?.order,
                        listener: (context, state) {
                          final order = state.address;


                          final locationBloc = context.read<LocationBloc>();
                          final cronometroBloc = context.read<CronometroBloc>();

                          if (order?.order == 'llego-conductor') {
                          
                            context
                                .read<PrecioDistanciaBloc>()
                                .add(const IniciarCalculoPrecioEvent());

                            final ubicacion =
                                locationBloc.state.lastKnownLocation;
                            if (ubicacion != null) {
                              context.read<PrecioDistanciaBloc>().add(
                                    ActualizarUbicacionEvent(
                                        ubicacion: ubicacion),
                                  );
                            }
                          } else {
                         
                            context
                                .read<PrecioDistanciaBloc>()
                                .add(const DetenerCalculoPrecioEvent());
                          }

                          if (state.address == null) {
                            cronometroBloc.add(const ResetCronometroEvent());
                          }

                          final hasValidOrder = order != null &&
                              order.id != null &&
                              order.id!.isNotEmpty;
                          final isAccepted = state.isAccepted;
                          final viajeFinalizado = order?.finalizado == true;
                          final hasDriverAssigned = order?.idDriver != null &&
                              order!.idDriver!.isNotEmpty;

                          // ✅ Controlar timer PERIÓDICO
                          if (hasValidOrder && hasDriverAssigned && isAccepted && !viajeFinalizado) {
                        
                            locationBloc.sendPeriodicPosition();
                          } else {
                       
                            locationBloc.stopPeriodicTask();
                          }
                        },
                        child: const BookingCard(),
                      ),

                      addressBloc.state.isPressed == true
                          ? const BtnArrived()
                          : Container()
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
