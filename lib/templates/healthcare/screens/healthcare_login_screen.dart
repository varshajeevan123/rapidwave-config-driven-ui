import 'package:flutter/material.dart';
import '../../../shared/widgets/animated_auth_screen.dart';

class HealthcareLoginScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const HealthcareLoginScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AnimatedAuthScreen(data: data);
  }
}
