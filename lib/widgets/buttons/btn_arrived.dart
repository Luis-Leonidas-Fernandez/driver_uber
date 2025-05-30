

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:inri_driver/blocs/blocs.dart';

import 'package:inri_driver/service/addresses_service.dart';

class BtnArrived extends StatelessWidget {
  const BtnArrived({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late AddressService addressService = AddressService();
    //final locationBloc = BlocProvider.of<LocationBloc>(context);
    final addressBloc = BlocProvider.of<AddressBloc>(context);

    final heigthScreen = MediaQuery.of(context).size.height;

    return Positioned(
      top: heigthScreen * 0.3,
      left: 320,
      right: 0,
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                    backgroundColor: Colors.indigo,
                    splashColor: Colors.white,
                    heroTag: UniqueKey(),
                    child: llego(),
                    onPressed: () async {
                      await addressService.arrivedDriver();

                      // Obtener el Address actual
                      final currentAddress = addressBloc.state.address;

                      if (currentAddress != null) {
                        // Crear un nuevo Address modificado manualmente con order = "llego-conductor"
                        final updatedAddress =
                            currentAddress.copyWith(order: 'llego-conductor');

                        // ACTUALIZAR AddressBloc localmente
                        addressBloc.add(AddAddressEvent(updatedAddress));
                      }

                      // OCULTAR BOTÓN LLEGO
                      addressBloc.add(OnLockBtnArriveEvent());

                })
              ]);
        },
      ),
    );
    //: Container();
  }
}

Widget llego() {
  return Text(
    "Llegó",
    style: GoogleFonts.lato(color: Colors.white, fontSize: 15),
    textAlign: TextAlign.end,
  );
}
