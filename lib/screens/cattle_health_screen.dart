import 'package:flutter/material.dart';

class CattleHealthScreen extends StatelessWidget {
  const CattleHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salud del Ganado')),
      body: const Center(child: Text('Gestión de Salud del Ganado')),
    );
  }
}
