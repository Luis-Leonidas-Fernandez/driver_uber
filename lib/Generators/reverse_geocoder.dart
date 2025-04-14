import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ReverseGeocodeText extends StatefulWidget {
  final List<double>? ubicacion;

  const ReverseGeocodeText({super.key, required this.ubicacion});

  @override
  State<ReverseGeocodeText> createState() => _ReverseGeocodeTextState();
}

class _ReverseGeocodeTextState extends State<ReverseGeocodeText> {
  
  String? direccion;
  bool cargando = true;

 @override
  void initState() {
    super.initState();
    _cargarDireccion();
  }


  @override
  Widget build(BuildContext context) {

  if (cargando) {
      return const Text(
        'Cargando dirección...',
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      direccion ?? '',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    );
  }

  Future<void> _cargarDireccion() async {
    final ubicacion = widget.ubicacion;
    if (ubicacion == null || ubicacion.length != 2) {
      setState(() {
        direccion = 'Ubicación no disponible';
        cargando = false;
      });
      return;
    }

    try {
      final placemarks = await placemarkFromCoordinates(ubicacion[1], ubicacion[0]);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final dir = '${place.street}, ${place.locality}';
        setState(() {
          direccion = dir;
          cargando = false;
        });
      } else {
        setState(() {
          direccion = 'Dirección no encontrada';
          cargando = false;
        });
      }
    } catch (e) {

      setState(() {
       direccion = 'Error: $e';
       cargando = false;
  });
}
  }
}

