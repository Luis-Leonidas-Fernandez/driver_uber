
import 'package:inri_driver/models/bases_conductor.dart';

class BaseSeleccionadaController {
  String? zonaName;
  int? base;

  void guardarBase(BaseConductor baseConductor) {
    zonaName = baseConductor.zonaName;
    base = baseConductor.base;
  }

  Map<String, dynamic> toJson() {
    return {
      'zonaName': zonaName,
      'base': base,
    };
  }

  void limpiar() {
    zonaName = null;
    base = null;
  }
}
