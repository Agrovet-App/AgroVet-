import 'package:flutter/material.dart';

class FeedingScreen extends StatelessWidget {
  const FeedingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alimentación')),
      body: const Center(child: Text('Gestión de Alimentación')),
    );
  }
}
