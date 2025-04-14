import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:inri_driver/animation/dragable_card.dart';
import 'package:inri_driver/blocs/address/address_bloc.dart';
import 'package:inri_driver/blocs/cronometro/cronometro_bloc.dart';
import 'package:inri_driver/blocs/location/location_bloc.dart';
import 'package:inri_driver/blocs/precioDistancia/precio_distancia_bloc.dart';
import 'package:inri_driver/constants/constants.dart';
import 'package:inri_driver/widgets/buttons/btn_reusable.dart';
import 'package:inri_driver/widgets/cards/car.dart';
import 'package:inri_driver/widgets/cards/container_details.dart';
import 'package:inri_driver/widgets/chronometer/cronometro.dart';
import 'package:inri_driver/widgets/dialogs/cancel_trip.dart';
import 'package:inri_driver/widgets/status/presentation_container.dart';

class BookingCard extends StatefulWidget {
  const BookingCard({super.key});

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {

  //final MessageService messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight <= 780;

    final sectionSpacing = isSmallScreen ? 6.0 : 10.0;
    final horizontalPadding = screenWidth < 375 ? 15.0 : 20.0;

    final locationBloc = BlocProvider.of<LocationBloc>(context);

    return DraggableCard(
      startTopFactor: 0.53,
      dragPercent: 0.35,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 550),
        decoration: _decorationContainerBookingCard(),
        child: BlocListener<LocationBloc, LocationState>(
          listenWhen: (previous, current) =>
          previous.lastKnownLocation != current.lastKnownLocation,
          listener: (context, state) {
             final ubicacion = state.lastKnownLocation;
            if (ubicacion != null) {
              context.read<PrecioDistanciaBloc>().add(
              ActualizarUbicacionEvent(ubicacion: ubicacion),
            );
           }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Fondo degradado inferior
              Positioned(
                top: 290,
                left: 0,
                right: 0,
                child: Container(
                  height: 260,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.cardColor.withAlpha(2),
                        AppConstants.cardColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                    ),
                  ),
                ),
              ),

              const Positioned(
                top: -60,
                left: 0,
                right: 0,
                child: AbsorbPointer(
                  absorbing: false,
                  child: SizedBox(
                    height: 110,
                    child: CarImage(),
                  ),
                ),
              ),

              // Mostrar boton para cancelar viaje

              Positioned(
                top: 8,
                right: 8,
                child: BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, state) {
                    final shouldShowCancel =
                        state.address?.id != null && state.isAccepted == false;

                    if (!shouldShowCancel) return const SizedBox.shrink();

                    return CancelTripIcon(
                      onCancel: (motivo) {
                        context.read<AddressBloc>().add(OnCancelTravel());
                        HydratedBloc.storage.write('AddressBloc', null);
                      },
                    );
                  },
                ),
              ),

              // Título y cupón
              Positioned(
                top: 50,
                left: 20,
                child: BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, state) {
                    final cuponValue = state.address?.cupon ?? '0';

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detalle Viaje',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: screenWidth <= 370 ? 55 : 90),
                        Row(
                          children: [
                            const Icon(Icons.discount_rounded,
                                color: Colors.white),
                            const SizedBox(width: 10),
                            const Text(
                              'Cupon',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '\$ $cuponValue',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              Positioned(
                top: 80,
                left: 20,
                child: BlocListener<AddressBloc, AddressState>(
                  listenWhen: (prev, curr) =>
                      prev.address?.horaEsperaInicio !=
                          curr.address?.horaEsperaInicio ||
                      prev.address?.horaEsperaFin !=
                          curr.address?.horaEsperaFin,
                  listener: (context, state) {
                    final horaInicio = state.address?.horaEsperaInicio;
                    final horaFin = state.address?.horaEsperaFin;
                    final cronometroBloc = context.read<CronometroBloc>();

                    if (horaInicio != null &&
                        cronometroBloc.state.horaEsperaInicio == null) {
                      cronometroBloc
                          .add(StartCronometroEvent(horaInicio: horaInicio));
                    }

                    if (horaFin != null) {
                      cronometroBloc.add(const StopCronometroEvent());
                    }
                  },
                  child: const CronometroWidget(),
                ),
              ),

              // Contenido dinámico
              Positioned(
                top: sectionSpacing * 12.5,
                left: horizontalPadding,
                right: horizontalPadding,
                child: BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, stateAddress) {
                    final order = stateAddress.address;
                    final idOrder = order?.id;
                    final idDriver = order?.idDriver;

                    // 🟢 Mostrar PresentationContainer SOLO si no hay orden
                    final isOrderMissing =
                        order == null || idOrder == null || idOrder.isEmpty;

                    if (isOrderMissing) {
                      return const PresentationContainer();
                    }

                    // ✅ Mostrar datos del cliente
                    final isDriverAssigned =
                        idDriver != null && idDriver.isNotEmpty;

                    if (isDriverAssigned) {
                      return const ContainerDetail();
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              // Botón dinámico
              _buttonsPedirFinalizar(screenHeight, isSmallScreen, locationBloc),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _buttonsPedirFinalizar(
      double screenHeight, bool isSmallScreen, LocationBloc locationBloc) {
    return Positioned(
      top: screenHeight * (isSmallScreen ? 0.365 : 0.375),
      left: 20,
      right: 20,
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, stateAddress) {
          // Botón "Aceptar Viaje"
          if (stateAddress.address?.id != null &&
              stateAddress.isAccepted == false) {
            return ButtonReusable(
              text: 'Aceptar viaje',
              onPressed: () async {
                final myLocation = locationBloc.state.lastKnownLocation;
                if (myLocation == null) return;
                // ✅ Confirmar viaje
                context.read<AddressBloc>().add(OnAcceptedTravel());
                context.read<AddressBloc>().add(OnIsAcceptedTravel());
                // ✅ Resetear distancia y precio ANTES de comenzar el nuevo viaje
                context.read<PrecioDistanciaBloc>().add(const ResetearPrecioDistanciaEvent());
                context.read<CronometroBloc>().add(const ResetCronometroEvent());

                //messageService.initPeriodicMessage();
               
              },
            );
          }

          // Botón "Finalizar"
          final order = stateAddress.address;
          final idOrder = order?.id;
          final hasOrder = idOrder != null && idOrder.isNotEmpty;

          if (hasOrder && stateAddress.isAccepted == true) {
            return ButtonReusable(
              text: 'Finalizar viaje',
              onPressed: () async {

                // 🧼 1. Detener emisión de ubicación
              locationBloc.stopPeriodicTask();

               // 🧼 2. Resetear cronómetro
              context.read<CronometroBloc>().add(const ResetCronometroEvent());

               // 🧼 3. Resetear precio por distancia
              context.read<PrecioDistanciaBloc>().add(const ResetearPrecioDistanciaEvent());

               // 🧼 4. Cancelar viaje (cambia estado, limpia orden)
              context.read<AddressBloc>().add(OnCancelTravel());

               // 🧼 5. Limpiar almacenamiento persistente
              HydratedBloc.storage.write('AddressBloc', null);
              
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  BoxDecoration _decorationContainerBookingCard() {
    return BoxDecoration(
      image: const DecorationImage(
        image: AssetImage('assets/background_image.webp'),
        fit: BoxFit.cover,
        opacity: 0.8,
      ),
      gradient: AppConstants.backgroundCard,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(255, 192, 191, 191),
          blurRadius: 25,
          spreadRadius: 1.0,
          offset: Offset(5, 0),
        ),
      ],
    );
  }
}
