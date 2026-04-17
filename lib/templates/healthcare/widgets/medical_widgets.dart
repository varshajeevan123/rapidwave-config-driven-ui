import 'dart:ui';
import 'package:flutter/material.dart';

class MedicalHexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    
    // Flatter hexagon for better content fitting
    path.moveTo(width * 0.5, 0); // Top center
    path.lineTo(width, height * 0.15); // Top right (was 0.25)
    path.lineTo(width, height * 0.85); // Bottom right (was 0.75)
    path.lineTo(width * 0.5, height); // Bottom center
    path.lineTo(0, height * 0.85); // Bottom left (was 0.75)
    path.lineTo(0, height * 0.15); // Top left (was 0.25)
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MedicalHexagonalPanel extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const MedicalHexagonalPanel({
    super.key,
    required this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: BoxConstraints(
        maxWidth: 750,
        minHeight: height ?? 0,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipPath(
        clipper: MedicalHexagonClipper(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1).withOpacity(0.3),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.3),
                  const Color(0xFF26A69A).withOpacity(0.05),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}


class MedicalAvatarHexagon extends StatelessWidget {
  const MedicalAvatarHexagon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00796B).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipPath(
        clipper: MedicalHexagonClipper(),
        child: Container(
          color: const Color(0xFF004D40),
          child: const Center(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}

class MedicalButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSecondary;

  const MedicalButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: isSecondary 
              ? [const Color(0xFFE0F2F1), const Color(0xFFB2DFDB)]
              : [const Color(0xFF00897B), const Color(0xFF00695C)],
          ),
          boxShadow: [
            BoxShadow(
              color: (isSecondary ? Colors.grey : const Color(0xFF004D40)).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isSecondary ? const Color(0xFF004D40) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
