import 'package:flutter/material.dart';

double getMaxWidth(double screenWidth, double factor) {
  if (screenWidth < 360) return screenWidth * factor * 0.9; // Teléfonos muy pequeños
  if (screenWidth < 600) return screenWidth * factor;       // Teléfonos normales
  return 372 * factor;                                      // Tablets o pantallas grandes
}

/// Calcula el ancho disponible para un input, tomando en cuenta
/// el ancho base del input, el ancho de un icono (si existe),
/// y un padding horizontal configurable.
double calcularAnchoDisponible({
  required BuildContext context,
  required double baseWidth,
  required double iconWidth,
  required double paddingHorizontal,
  bool isFullWidth = false,
}) {

  
  if (isFullWidth) {
    // Caso 100% de ancho (como Tipo de carga), ignora el cálculo adicional.
    return MediaQuery.of(context).size.width * 0.9;
  }

  // Caso normal para inputs en filas compartidas.
  return baseWidth + iconWidth + (2 * paddingHorizontal);
}
