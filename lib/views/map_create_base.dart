import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inri_driver/animation/navigate_to_login.dart';
import 'package:inri_driver/animation/onda_class.dart';
import 'package:inri_driver/blocs/base/base_bloc.dart';
import 'package:inri_driver/controllers/base_controllers.dart';
import 'package:inri_driver/models/base.dart';
import 'package:inri_driver/service/base_service.dart';
import 'package:inri_driver/widgets/dialogs/alert_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:inri_driver/blocs/blocs.dart';


class MapCreateBase extends StatefulWidget {
  const MapCreateBase({Key? key}) : super(key: key);

  @override
  State<MapCreateBase> createState() => _MapCreateBaseState();
}

class _MapCreateBaseState extends State<MapCreateBase> {
  late final LocationBloc locationBloc;
  late final MapController _mapController;
  final baseSeleccionadaController = BaseSeleccionadaController();
  late final AuthBloc authBloc;
  late final BaseBloc baseBloc;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    locationBloc = context.read<LocationBloc>();
    locationBloc.startFollowingUser();

    authBloc = context.read<AuthBloc>();
    baseBloc = context.read<BaseBloc>();
    baseBloc.getAllBasesAndSaveInBloc();

    final mapBloc = context.read<MapBloc>();
    mapBloc.initBackgroundService();

    _mapController = MapController();
    mapBloc.add(OnMapInitializeEvent(_mapController));
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, locationState) {
        final myLocation = locationState.lastKnownLocation;

        if (myLocation == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final usuario = authBloc.state.usuario;
        if (usuario == null && !_navigated) {
          _navigated = true;
          navigateToLogin(context);
          return const SizedBox.shrink();
        }
        if (usuario == null) {
          return const SizedBox();
        }

        final baseService = BaseService();
        final userLocation = [myLocation.latitude, myLocation.longitude];
        final mapBloc = context.read<MapBloc>();
        final center = mapBloc.bounds(userLocation);
        final bases = baseBloc.state.basesDisponibles ?? [];

        final List<Marker> baseMarkers = bases.map((base) {
          final ubicacion = base.ubicacion;
          if (ubicacion == null) {
            return const Marker(point: LatLng(0, 0), child: SizedBox());
          }

          return Marker(
            point: ubicacion,
            width: 57,
            height: 57,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Base ${base.zonaName}'),
                    content: const Text('¿Deseás suscribirte a esta base?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          baseSeleccionadaController.guardarBase(base);

                          final baseModel = BaseModel(
                            zona: baseSeleccionadaController.zonaName,
                            base: baseSeleccionadaController.base.toString(),
                          );

                          context.read<BaseBloc>().add(AddBaseEvent(baseModel));
                          Navigator.of(context).pop();

                          await Future.delayed(const Duration(milliseconds: 100));
                          final registerOk = await baseService.addDriverToBase(baseModel);

                          if (registerOk && context.mounted) {
                            final usuario = context.read<AuthBloc>().state.usuario;
                            if (usuario != null) {
                              final usuarioActualizado =
                                  usuario.copyWith(base: baseModel.base);
                              context
                                  .read<AuthBloc>()
                                  .add(OnUpdateUserEvent(usuarioActualizado));
                            }
                            mostrarAlerta(
                              context,
                              'Registro exitoso',
                              'Estás suscripto a una base',
                            );
                          } else {
                            if (!context.mounted) return;
                            mostrarAlerta(
                              context,
                              'Base no activa',
                              'Elige otra desde el menú de opciones',
                            );
                          }
                        },
                        child: const Text('Suscribirse'),
                      ),
                    ],
                  ),
                );
              },
              child: Column(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 40),
                  Text(
                    base.zonaName ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        }).toList();

        return Scaffold(
          body: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              minZoom: 1.0,
              maxZoom: 20.0,
            ),
            children: [
              TileLayer(
                urlTemplate: usuario.urlMapbox,
                additionalOptions: {
                  'accessToken': usuario.tokenMapBox,
                  'id': usuario.idMapBox,
                },
              ),
              MarkerLayer(
                markers: [
                  RippleMarker(
                    position: LatLng(myLocation.latitude, myLocation.longitude),
                    iconPath: 'assets/car2.webp',
                    size: 70,
                  ).build(),
                  ...baseMarkers,
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}