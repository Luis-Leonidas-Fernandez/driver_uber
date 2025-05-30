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
  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;
    //final isSmallScreen = screenHeight <= 780;

    //final sectionSpacing = isSmallScreen ? 6.0 : 10.0;
    //final horizontalPadding = screenWidth < 375 ? 15.0 : 20.0;

    final locationBloc = BlocProvider.of<LocationBloc>(context);

    return DraggableCard(
      startTopFactor: 0.47,
      dragPercent: 0.35,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) { 

          final screenWidth =  constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          final isSmallScreen = screenHeight <= 780;

          final sectionSpacing = isSmallScreen ? 6.0 : 10.0;
          final horizontalPadding = screenWidth < 375 ? 15.0 : 20.0;


          return Container(
          constraints: const BoxConstraints(maxHeight: 550),
          decoration: _decorationContainerBookingCard(),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
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
                      prev.address?.order != curr.address?.order,
                  listener: (context, state) {
                    final horaInicio = state.address?.horaEsperaInicio;
                    final order = state.address?.order ?? '';
                    final cronometroBloc = context.read<CronometroBloc>();
        
                    if (order == 'llego-conductor' &&
                        horaInicio != null &&
                        cronometroBloc.state.horaEsperaInicio == null) {
                      cronometroBloc
                          .add(StartCronometroEvent(horaInicio: horaInicio));
                    }
        
                    if (state.address?.horaEsperaFin != null) {
                      cronometroBloc.add(const StopCronometroEvent());
                    }
                  },
                  child: const CronometroWidget(),
                ),
              ),
              Positioned(
                top: sectionSpacing * 12.0,
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: 20,
                child: SizedBox(
                  height: screenHeight * 0.5,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const SizedBox(height: 10),
                      BlocBuilder<AddressBloc, AddressState>(
                        builder: (context, stateAddress) {
                          final order = stateAddress.address;
                          final idOrder = order?.id;
                          final estado = order?.order ?? '';
                          final isOrderMissing =
                              order == null || idOrder == null || idOrder.isEmpty;
        
                          if (isOrderMissing) {
                            return const PresentationContainer();
                          }
        
                          final isOrderValid = estado == 'libre' ||
                              estado == 'en-camino' ||
                              estado == 'llego-conductor';
        
                          if (idOrder.isNotEmpty && isOrderValid) {
                            return const ContainerDetail();
                          }
        
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 18),
        
                      // Botón dinámico original agregado al final del ListView
                      _buttonsPedirFinalizar(
                          screenHeight, isSmallScreen, locationBloc),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
         },
        
      ),
    );
  }

  Widget _buttonsPedirFinalizar(
      double screenHeight, bool isSmallScreen, LocationBloc locationBloc) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, stateAddress) {
        final locationBloc = BlocProvider.of<LocationBloc>(context);

        const horizontalMargin = 0.0;

        if (stateAddress.address?.id != null &&
            stateAddress.isAccepted == false) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalMargin),
            child: ButtonReusable(
              text: 'Aceptar viaje',
              onPressed: () async {
                final myLocation = locationBloc.state.lastKnownLocation;
                if (myLocation == null) return;
                context.read<AddressBloc>().add(OnAcceptedTravel());
                context.read<AddressBloc>().add(OnIsAcceptedTravel());
                context
                    .read<PrecioDistanciaBloc>()
                    .add(const ResetearPrecioDistanciaEvent());
                context
                    .read<CronometroBloc>()
                    .add(const ResetCronometroEvent());
              },
            ),
          );
        }

        final order = stateAddress.address;
        final idOrder = order?.id;
        final hasOrder = idOrder != null && idOrder.isNotEmpty;

        if (hasOrder && stateAddress.isAccepted == true) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalMargin),
            child: ButtonReusable(
              text: 'Finalizar viaje',
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('¿Finalizar viaje?'),
                    content: const Text(
                        '¿Estás seguro de que deseas finalizar el viaje? Esta acción no se puede deshacer.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Finalizar',
                        style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                );

                if (confirmed != true) return;
                if (!context.mounted) return;

                locationBloc.stopPeriodicTask();
                context.read<AddressBloc>().add(FinishOrderEvent());
                context
                    .read<CronometroBloc>()
                    .add(const ResetCronometroEvent());
                context
                    .read<PrecioDistanciaBloc>()
                    .add(const ResetearPrecioDistanciaEvent());
                HydratedBloc.storage.write('AddressBloc', null);
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
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
