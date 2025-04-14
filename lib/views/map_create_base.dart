import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inri_driver/animation/navigate_to_login.dart';
import 'package:inri_driver/animation/onda_class.dart';
import 'package:inri_driver/blocs/base/base_bloc.dart';
import 'package:inri_driver/controllers/base_controllers.dart';
import 'package:inri_driver/models/base.dart';
import 'package:inri_driver/models/bases_conductor.dart';
import 'package:inri_driver/models/usuario.dart';
import 'package:inri_driver/service/auth_service.dart';
import 'package:inri_driver/service/base_service.dart';
import 'package:inri_driver/widgets/dialogs/alert_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:provider/provider.dart';





class MapCreateBase extends StatefulWidget {
  const MapCreateBase({Key? key}) : super(key: key);

  @override
  State<MapCreateBase> createState() => _MapCreateBaseState();
}

class _MapCreateBaseState extends State<MapCreateBase> {
  late LocationBloc locationBloc;
  late final MapController _mapController;
  final baseSeleccionadaController = BaseSeleccionadaController();
  late Usuario usuario;
  AuthService? authService;
  AuthBloc? authBloc;
  BaseBloc? baseBloc;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<BaseBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();

    final mapBloc = BlocProvider.of<MapBloc>(context);
    mapBloc.initBackgroundService();

    _mapController = MapController();
    context.read<MapBloc>().add(OnMapInitializeEvent(_mapController));

    final baseBloc = BlocProvider.of<BaseBloc>(context, listen: false);
    baseBloc.getAllBasesAndSaveInBloc(baseBloc);
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late BaseService baseService = BaseService();
    final usuario = Provider.of<AuthBloc>(context).state.usuario;
   
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final myLocation = locationBloc.state.lastKnownLocation ??
        const LatLng(-27.452786, -58.985812);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final userLocation = [myLocation.latitude, myLocation.longitude];
    

    final center = (() {
      final LatLng calculated = mapBloc.bounds(userLocation);
      return calculated;
    })();

    final baseBloc = context.watch<BaseBloc>();
    final List<BaseConductor> bases = baseBloc.state.basesDisponibles ?? [];
    
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
                      // 1. Guardar la base seleccionada en el controller
                      baseSeleccionadaController.guardarBase(base);

                      // 2. Crear el modelo con los datos para el backend
                      final baseModel = BaseModel(
                        zona: baseSeleccionadaController.zonaName,
                        base: baseSeleccionadaController.base.toString(),
                      );

                      // 3. Emitir el evento al BaseBloc
                      context.read<BaseBloc>().add(AddBaseEvent(baseModel));

                      // 4. Cerrar el diálogo
                      Navigator.of(context).pop(); // cerrar el diálogo

                      await Future.delayed(const Duration(milliseconds: 100));

                      // 5. Llamar al backend para registrar al conductor en la base
                      final registerOk = await baseService.addDriverToBase(baseModel);
                   

                      if (registerOk && context.mounted) {
                       

                        final usuario = context.read<AuthBloc>().state.usuario;

                        if (usuario != null) {
                          final usuarioActualizado = usuario.copyWith(base: baseModel.base);
                          context.read<AuthBloc>().add(OnUpdateUserEvent(usuarioActualizado));
                        }

                        // Mostrar alerta de éxito
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
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state.usuario;
          
          if (user == null && !_navigated) {
          _navigated = true;
          navigateToLogin(context);
          return const Center(child: CircularProgressIndicator());
          }
          
          if (user == null) {
          return const SizedBox(); // Protección extra
          }
          
          
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              minZoom: 1.0,
              maxZoom: 20.0,
            ),
            children: [
              TileLayer(
                urlTemplate: usuario?.urlMapbox,
                additionalOptions: {
                  'accessToken': usuario?.tokenMapBox ?? '',
                  'id': usuario?.idMapBox ?? '',
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
          );
        },
      ),
    );
  }
}
