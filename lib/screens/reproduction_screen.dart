import 'package:flutter/material.dart';

class ReproductionScreen extends StatelessWidget {
  const ReproductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reproducción')),
      body: const Center(child: Text('Gestión de Reproducción')),
    );
  }
}
