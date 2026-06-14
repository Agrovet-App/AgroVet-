import 'package:flutter/material.dart';
import 'package:agrovet/utils/app_theme.dart';

class CattleHealthScreen extends StatelessWidget {
  const CattleHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Salud del Ganado'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Text(
              'Gestión de Salud del Ganado',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: AppColors.black),
            ),
          ),
        ),
      ),
    );
  }
}
