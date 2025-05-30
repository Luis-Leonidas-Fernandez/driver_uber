import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_driver/blocs/cronometro/cronometro_bloc.dart';
import 'package:inri_driver/blocs/address/address_bloc.dart';
import 'package:inri_driver/blocs/precioDistancia/precio_distancia_bloc.dart';

class CronometroWidget extends StatelessWidget {
  const CronometroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final order = context.watch<AddressBloc>().state.address;
    final horaInicio = order?.horaEsperaInicio;

    if (horaInicio == null) return const SizedBox.shrink();

    return BlocBuilder<PrecioDistanciaBloc, PrecioDistanciaState>(
      builder: (context, stateDistancia) {
        final precioDistancia = stateDistancia.precioActual;

        return BlocBuilder<CronometroBloc, CronometroState>(
          builder: (context, state) {
            final isRunning = state.isRunning!;
            //final double precioPorDistancia = order?.precio ?? 0.0;
            final double precioTotal = precioDistancia + state.price;


            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  shape: const CircleBorder(),
                  color: isRunning ? Colors.greenAccent : Colors.redAccent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    splashColor: Colors.white54,
                    highlightColor: Colors.white10,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if (isRunning) {
                        final now = DateTime.now();
                        context
                            .read<CronometroBloc>()
                            .add(const StopCronometroEvent());
                        context
                            .read<AddressBloc>()
                            .add(OnGuardarHoraEsperaFin(now));
                      } else {
                        context.read<CronometroBloc>().add(
                              StartCronometroEvent(horaInicio: horaInicio),
                            );
                      }
                    },
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.access_time,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                //Precio de espera
                Container(
                  width: 130,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.formattedDuration,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$ ${state.price.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // 💰 TOTAL
                Container(
                  width: 150,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.purple[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order?.order == 'llego-conductor'
                        ? 'Total: \$ ${precioTotal.toStringAsFixed(0)}'
                        : '\$ 0',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
