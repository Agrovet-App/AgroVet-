import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agrovet/services/firestore_service.dart';

class RegisterAnimalScreen extends StatefulWidget {
  const RegisterAnimalScreen({super.key});

  @override
  State<RegisterAnimalScreen> createState() => _RegisterAnimalScreenState();
}

class _RegisterAnimalScreenState extends State<RegisterAnimalScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  late final FirestoreService _firestoreService;

  String? _selectedSpecies;
  String? _selectedGender;
  bool _isLoading = false;

  final List<String> _species = [
    'Vaca',
    'Caballo',
    'Cerdo',
    'Oveja',
    'Cabra',
    'Pollo'
  ];

  final List<String> _genders = ['Macho', 'Hembra'];

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveAnimal() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSpecies == null || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona especie y sexo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario no autenticado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final animalId = const Uuid().v4();

      final animalData = {
        'id': animalId,
        'ganaderoId': user.uid, // 🔥 FIX IMPORTANTE
        'nombre': _nameController.text.trim(),
        'especie': _selectedSpecies,
        'raza': _breedController.text.trim(),
        'edad': int.tryParse(_ageController.text) ?? 0,
        'peso': double.tryParse(_weightController.text) ?? 0.0,
        'sexo': _selectedGender,
        'notasMedicas': _notesController.text.trim(),
        'estado': 'activo',
        'creadoEn': DateTime.now().toIso8601String(),
        'actualizadoEn': DateTime.now().toIso8601String(),
      };

      await _firestoreService.createAnimal(animalId, animalData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Animal registrado exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const RegisterAnimalScreen(),
  ),
);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar animal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Animal'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // ESPECIE
              DropdownButtonFormField<String>(
                value: _selectedSpecies,
                items: _species
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedSpecies = v),
                decoration: const InputDecoration(
                  labelText: 'Especie',
                ),
              ),

              const SizedBox(height: 10),

              // NOMBRE
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    v!.isEmpty ? 'Ingresa el nombre' : null,
              ),

              const SizedBox(height: 10),

              // RAZA
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Raza'),
              ),

              const SizedBox(height: 10),

              // EDAD
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Edad'),
              ),

              const SizedBox(height: 10),

              // PESO
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Peso'),
              ),

              const SizedBox(height: 10),

              // SEXO
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: _genders
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedGender = v),
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                ),
              ),

              const SizedBox(height: 10),

              // NOTAS
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration:
                    const InputDecoration(labelText: 'Notas médicas'),
              ),

              const SizedBox(height: 20),

              // BOTÓN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAnimal,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Guardar Animal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}