import 'package:flutter/material.dart';

class CustomShimmer extends StatefulWidget {
  final Widget child;
  const CustomShimmer({super.key, required this.child});

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.1, 0.5, 0.9],
              begin: Alignment(-1.0 - 2.0 * _controller.value, 0),
              end: const Alignment(1.0, 0),
            ).createShader(bounds);
          },
          blendMode: BlendMode.modulate,
          child: widget.child,
        );
      },
    );
  }
}

class ShimmerLoadingHome extends StatelessWidget {
  const ShimmerLoadingHome({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox.expand(
      child: Stack(
        children: [
          // Fondo tipo mapa
          CustomShimmer(
            child: Container(
              width: double.infinity,
              height: size.height,
              color: Colors.grey[300],
            ),
          ),

          // icons location
          Positioned(
            top: size.height * 0.35,
            left: size.width * 0.4,
            child: CustomShimmer(
              child: Icon(
                Icons.location_on,
                size: 36,
                color: Colors.grey[100],
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.5,
            right: size.width * 0.25,
            child: CustomShimmer(
              child: Icon(
                Icons.location_on,
                size: 36,
                color: Colors.grey[100],
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.2,
            left: size.width * 0.2,
            child: CustomShimmer(
              child: Icon(
                Icons.location_on,
                size: 36,
                color: Colors.grey[100],
              ),
            ),
          ),

          // AppBar personalizado shimmer
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // "Hola, Marco"
                CustomShimmer(
                  child: Container(
                    height: 24,
                    width: 120,
                    color: Colors.grey[100],
                  ),
                ),
                // Perfil + Logout
                Row(
                  children: [
                    // Icono de perfil
                    CustomShimmer(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Icono de logout
                    CustomShimmer(
                      child: Icon(
                        Icons.logout,
                        size: 28,
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // BookingCard shimmer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomShimmer(
              child: Container(
                height: 250,
                margin: const EdgeInsets.all(16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Línea superior (Detalle viaje / Cupón)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 16,
                          width: 120,
                          color: Colors.grey[100],
                        ),
                        Container(
                          height: 16,
                          width: 80,
                          color: Colors.grey[100],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Cuadro promocional simulado
                    Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Botón "Pedir Ahora" shimmer simulado
                    Center(
                      child: Container(
                        height: 48,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
