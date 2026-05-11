import 'package:flutter/material.dart';

class MyFarmScreen extends StatefulWidget {
  const MyFarmScreen({super.key}); // Nombre del constructor corregido

  @override
  State<MyFarmScreen> createState() => _MyFarmScreenState(); // Nombre del estado corregido
}

class _MyFarmScreenState extends State<MyFarmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Registrar animal',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Avatar con botón de agregar foto
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF3A736A).withOpacity(0.2), width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.pets, size: 40, color: Color(0xFF3A736A)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('+ Agregar foto', style: TextStyle(color: Color(0xFF3A736A))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Selector de Especie (Bovino, Cabra, etc)
            _buildLabel('ESPECIE'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _speciesChip('Bovino', Icons.agriculture, true),
                _speciesChip('Cabra', Icons.pest_control_rodent, false),
                _speciesChip('Toro', Icons.pest_control_rodent, false),
                _speciesChip('Cría', Icons.child_care, false),
              ],
            ),
            const SizedBox(height: 24),

            // Campos de texto: Nombre y Raza
            Row(
              children: [
                Expanded(child: _buildTextField('NOMBRE', 'Rocky')),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('RAZA', 'Brahman...')),
              ],
            ),
            const SizedBox(height: 16),

            // Campos de texto: Edad y Peso
            Row(
              children: [
                Expanded(child: _buildTextField('EDAD', '3 años')),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('PESO (KG)', '12.5')),
              ],
            ),
            const SizedBox(height: 16),

            // Sexo
            _buildLabel('SEXO'),
            const SizedBox(height: 10),
            Row(
              children: [
                _sexChip('Macho', true),
                const SizedBox(width: 12),
                _sexChip('Hembra', false),
              ],
            ),
            const SizedBox(height: 32),

            // Botón Guardar
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A736A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Guardar ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Icon(Icons.pets, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _speciesChip(String label, IconData icon, bool isSelected) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3A736A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.2)),
          ),
          child: Icon(icon, color: isSelected ? Colors.white : Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: isSelected ? const Color(0xFF3A736A) : Colors.grey)),
      ],
    );
  }

  Widget _sexChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFEBD2) : Colors.white, // Color naranja clarito de la foto
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFFF5A623) : Colors.grey.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? const Color(0xFFF5A623) : Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }
}