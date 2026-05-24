
import 'package:flutter/material.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:hexcolor/hexcolor.dart';

class ErrorDisplayWidget extends StatelessWidget {
  
  final AuthState state;
  final VoidCallback onClearError;
  
  const ErrorDisplayWidget({
    super.key,
    required this.state,
    required this.onClearError,
  });

  @override
  Widget build(BuildContext context) {
    if (!state.hasError) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            HexColor("#FF6B6B").withValues(alpha: 0.1),
            HexColor("#FF8E8E").withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: HexColor("#FF6B6B").withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: HexColor("#FF6B6B").withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: HexColor("#FF6B6B").withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: HexColor("#FF6B6B"),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              state.errorMessage ?? 'Error desconocido',
              style: TextStyle(
                color: HexColor("#FF6B6B"),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onClearError,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: HexColor("#FF6B6B").withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.close_rounded,
                color: HexColor("#FF6B6B"),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}