// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:inri_driver/constants/app_bar.dart';
import 'package:inri_driver/models/address.dart';
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

class _HomePageState extends State<HomePage> {
  AddressBloc? addressBloc;
  LocationBloc? locationBloc;
  AuthBloc? usuarioBloc;
  Usuario? usuario;

  @override
  void initState() {
    super.initState();

    final locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();

    final addressBloc = BlocProvider.of<AddressBloc>(context);

    addressBloc.state.loading;
    addressBloc.startLoadingAddress();

    final mapBloc = BlocProvider.of<MapBloc>(context);
    mapBloc.initBackgroundService();

    BlocProvider.of<LocationBloc>(context);
    BlocProvider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    locationBloc?.stopFollowingUser();
    locationBloc?.stopPeriodicTask();
    addressBloc?.stopLoadingAddress();
    usuarioBloc?.deleteUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioBloc = BlocProvider.of<AuthBloc>(context);
    final addressBloc = BlocProvider.of<AddressBloc>(context);

    addressBloc.state.loading;

    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        final hasLocation = state.lastKnownLocation != null;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: hasLocation ? AppBarConstants.customAppBar(context) : null,
          body: BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              if (state.lastKnownLocation == null) return const ShimmerLoadingHome();
              final long = (state.lastKnownLocation!.longitude);
              final lat = state.lastKnownLocation!.latitude;

              return StreamBuilder(
                  stream: addressBloc.getOrder(),
                  builder: (context, AsyncSnapshot<Address> snapshot) {
                    return SingleChildScrollView(
                      child: Stack(
                        children: [


                          usuarioBloc.state.usuario != null
                              ? MapView(initialLocation: LatLng(lat, long))
                              : Container(),


                          BlocListener<AddressBloc, AddressState>(
                            listenWhen: (previous, current) =>
                                previous.address?.id != current.address?.id || // nueva orden
                                previous.isAccepted != current.isAccepted  ||
                                previous.address?.order != current.address?.order,
                            listener: (context, state) {

                              final order = state.address;
                              print('🧪 Estado actual del order: ${order?.order}');

                              final locationBloc = context.read<LocationBloc>();
                              final cronometroBloc = context.read<CronometroBloc>();
                              //final precioDistanciaBloc = context.read<PrecioDistanciaBloc>();

                              if (order?.order == 'llego-conductor') {
                              print('✅ [Listener] Detectado order = llego-conductor'); 
                              context.read<PrecioDistanciaBloc>().add(const IniciarCalculoPrecioEvent());
                              print('🚀 Evento IniciarCalculoPrecioEvent enviado');
                              } else {
                              print('⛔ [Listener] Order distinto de "llego-conductor", se detiene cálculo'); 
                              context.read<PrecioDistanciaBloc>().add(const DetenerCalculoPrecioEvent());

                              }

                              final lastLocation = context.read<LocationBloc>().state.lastKnownLocation;
                               print('📍 [Listener] Última ubicación del conductor: $lastLocation');
                              if (lastLocation != null) {
                              print('📍 [BlocListener] Forzando ubicación inicial: $lastLocation');
                              context.read<PrecioDistanciaBloc>().add(
                              ActualizarUbicacionEvent(ubicacion: lastLocation),
                              );
                              }

                              if (state.address == null) {
                                print( '🧹 Reiniciando Cronómetro porque no hay viaje activo');
                                cronometroBloc.add(const ResetCronometroEvent());
                              }

                              final hasOrder = order?.id != null && order?.idDriver != null;
                              final isAccepted = state.isAccepted;

                              print('📦 [Listener] hasOrder: $hasOrder | isAccepted: $isAccepted');

                              if (hasOrder && state.isAccepted) {
                                print( '🛰️ [Acción] Iniciando envío periódico...');
                                locationBloc.sendPeriodicPosition();
                              } else {
                                print( '⛔ [Acción] Deteniendo envío periódico...');
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
                  });
            },
          ),
        );
      },
    );
  }
}
