import 'package:flutter/material.dart';

class CancelTripIcon extends StatelessWidget {
  final void Function(String motivo) onCancel;

  const CancelTripIcon({
    super.key,
    required this.onCancel,
  });

  void _mostrarMotivosCancelacion(BuildContext context) {
    final motivos = [
      'Demasiado lejos',
      'Estoy ocupado',
      'No me gusta la zona',
      'Error en la asignación',
      'Otro motivo',
    ];

    String? motivoSeleccionado;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('¿Por qué deseas cancelar?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: motivos.map((motivo) {
              return RadioListTile<String>(
                title: Text(motivo),
                value: motivo,
                groupValue: motivoSeleccionado,
                onChanged: (valor) {
                  setState(() {
                    motivoSeleccionado = valor;
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver'),
            ),
            ElevatedButton(
              onPressed: motivoSeleccionado == null
                  ? null
                  : () {
                      //  Aqui llamar el endpoint que 
                      //  elimina el idDriver de la Order 
                      //  y lo agrega a la blackList de 
                      //  la misma
                      Navigator.pop(context);
                      onCancel(motivoSeleccionado!);
                    },
              child: const Text('Cancelar viaje'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close, color: Colors.white),
      onPressed: () => _mostrarMotivosCancelacion(context),
    );
  }
}
