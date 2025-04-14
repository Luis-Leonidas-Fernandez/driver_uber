
import 'package:flutter_map/flutter_map.dart';
import 'package:inri_driver/animation/ripple_icon.dart';
import 'package:latlong2/latlong.dart';

class RippleMarker {
  final LatLng position;
  final String iconPath;
  final double size;

  RippleMarker({
    required this.position,
    required this.iconPath,
    this.size = 70,
  });

  Marker build() {
    return Marker(
      point: position,
      width: size * 2.5,
      height: size * 2.5,
      child: RippleIcon(iconPath: iconPath, size: size),
    );
  }
}