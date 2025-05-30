

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inri_driver/animation/onda_class.dart';
import 'package:inri_driver/models/usuario.dart';
import 'package:inri_driver/service/auth_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  final LatLng initialLocation;

  const MapView({Key? key, required this.initialLocation}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late LocationBloc locationBloc;
  late AddressBloc addressBloc;
  late final MapController _mapController;
  late Usuario usuario;
  AuthService? authService;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<AuthBloc>(context, listen: false);
    BlocProvider.of<LocationBloc>(context);
    addressBloc = BlocProvider.of<AddressBloc>(context);
    BlocProvider.of<MapBloc>(context);
    _mapController = MapController();
    context.read<MapBloc>().add(OnMapInitializeEvent(_mapController));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final usuario = Provider.of<AuthBloc>(context).state.usuario;

    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final myLocation = locationBloc.state.lastKnownLocation!;
   
    final location = addressBloc.state.address?.ubicacion == null? null: addressBloc.state.address!.ubicacion;
    final destination = addressBloc.state.address?.destino == null ? null: addressBloc.state.address!.destino;

    final mapBloc = BlocProvider.of<MapBloc>(context);
    final userLocation = location ?? [];
    final userDestination = destination ?? [];

    /// desplazamos el centro manualmente hacia arriba
    final center = (() {
      final LatLng calculated = mapBloc.bounds(userLocation);
      return calculated;
    })();

    final size = MediaQuery.of(context).size;


    return SizedBox(
      width: size.width,
      height: size.height,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
        
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              //zoom: zoom,
              initialCenter: center,
              minZoom: 1.0,
              maxZoom: 20.0,
            ),
            children: [
              TileLayer(
                urlTemplate: usuario!.urlMapbox,
                additionalOptions: {
                  'accessToken': usuario.tokenMapBox,
                  'id': usuario.idMapBox,
                },
              ),
              MarkerLayer(
                markers: [
                  RippleMarker(
                          position:
                              LatLng(myLocation.latitude, myLocation.longitude),
                          iconPath: 'assets/car2.webp',
                          size: 70)
                      .build(),
                  if (userLocation.isNotEmpty)
                    RippleMarker(
                            position: LatLng(location![1], location[0]),
                            iconPath: 'assets/icon.webp',
                            size: 70)
                        .build(),
                  if (userDestination.isNotEmpty)
                    Marker(
                        width: 100,
                        height: 100,
                        point: LatLng(userDestination[1], userDestination[0]),
                        child: Column(children: [
                          Container(
                            width: 80,
                            height: 30,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Destino',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.location_on,
                            size: 45,
                            color: Colors.red,
                          ),
                        ]))
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
