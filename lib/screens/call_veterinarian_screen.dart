import 'package:flutter/material.dart';

class CallVeterinarianScreen extends StatelessWidget {
  const CallVeterinarianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Llamar a un Doctor')),
      body: const Center(child: Text('Llamar a un Doctor Veterinario')),
    );
  }
}
