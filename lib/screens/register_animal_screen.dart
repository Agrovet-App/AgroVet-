import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agrovet/utils/app_theme.dart';
import 'package:agrovet/models/animal.dart';

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

  AnimalSpecies? _selectedSpecies;
  AnimalGender? _selectedGender;
  String? _photoPath;
  bool _isLoading = false;

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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSpecies == null || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona especie y sexo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simular guardado
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Animal registrado exitosamente!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Animal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto del animal
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Implementar selector de foto
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.camera,
                            color: AppColors.primary,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Agregar foto',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Especie
                const Text(
                  'ESPECIE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildSpeciesButton('Bovino', AnimalSpecies.bovino),
                      _buildSpeciesButton('Cabra', AnimalSpecies.cabra),
                      _buildSpeciesButton('Toro', AnimalSpecies.toro),
                      _buildSpeciesButton('Cite', AnimalSpecies.cite),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Nombre
                const Text(
                  'NOMBRE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Ej: Rocky',
                    prefixIcon: Icon(Icons.pets),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Por favor ingresa el nombre del animal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Raza
                const Text(
                  'RAZA',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _breedController,
                  decoration: const InputDecoration(
                    hintText: 'Ej: Brahman',
                    prefixIcon: Icon(Icons.info),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Por favor ingresa la raza';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Edad y Peso
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'EDAD',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Años',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Requerido';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PESO (KG)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Kg',
                              prefixIcon: Icon(Icons.scale),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Requerido';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Sexo
                const Text(
                  'SEXO',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildGenderButton('Macho', AnimalGender.macho),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGenderButton('Hembra', AnimalGender.hembra),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Notas Médicas
                const Text(
                  'NOTAS MÉDICAS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Ej: afición bruxcelosis',
                    prefixIcon: Icon(Icons.notes),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 32),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.of(context).pop();
                              },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Omitir'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveAnimal,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeciesButton(String label, AnimalSpecies species) {
    final isSelected = _selectedSpecies == species;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedSpecies = selected ? species : null;
          });
        },
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGenderButton(String label, AnimalGender gender) {
    final isSelected = _selectedGender == gender;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedGender = selected ? gender : null;
        });
      },
      selectedColor: isSelected
          ? (gender == AnimalGender.macho ? Colors.orange : Colors.pink)
          : Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
