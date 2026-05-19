import 'dart:io';

import 'package:flutter/material.dart';
import 'package:agrovet/services/firestore_service.dart';
import 'package:agrovet/services/auth_service.dart';
import 'package:agrovet/utils/app_theme.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UpdateVeterinarianProfileScreen extends StatefulWidget {
  const UpdateVeterinarianProfileScreen({super.key});

  @override
  State<UpdateVeterinarianProfileScreen> createState() =>
      _UpdateVeterinarianProfileScreenState();
}

class _UpdateVeterinarianProfileScreenState
    extends State<UpdateVeterinarianProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _authService = AuthService();
  final _firestoreService = FirestoreService();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _professionalIdController = TextEditingController();
  final _clinicNameController = TextEditingController();
  String? _selectedSpecialty;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool _isSaving = false;

  String? _currentPhotoUrl;
  String? _uid;

  final specialties = [
    'Medicina General',
    'Cirugía',
    'Oftalmología',
    'Dermatología',
    'Medicina Interna',
    'Odontología',
    'Reproducción',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _professionalIdController.dispose();
    _clinicNameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      // Intentar obtener uid desde AuthService
      final user = _authService.getCurrentUser();
      final uid = user?.uid;

      // Debug para validar que el uid autenticado coincide con el doc en Firestore
      // (vital cuando Firestore devuelve null por read-denied o uid distinto).
      debugPrint('UpdateVeterinarianProfileScreen: currentUser.uid=$uid');

      if (uid == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se encontró el usuario autenticado.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
        return;
      }

      _uid = uid;

      // Debug: verificar que el uid exista también como doc en Firestore.
      debugPrint('UpdateVeterinarianProfileScreen: leyendo doc veterinarios/$uid');

      Map<String, dynamic>? vetData;
      try {
        vetData = await _firestoreService.getVeterinarianData(uid);
      } catch (e) {
        debugPrint('UpdateVeterinarianProfileScreen: error getVeterinarianData($uid): $e');
        rethrow;
      }

      if (vetData == null) {

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se encontraron datos del veterinario en veterinarios/${uid}. Verifica que el doc exista y que estés en el mismo proyecto Firebase.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }


      _currentPhotoUrl = vetData['fotoUrl']?.toString();

      _nameController.text = (vetData['nombreCompleto'] ?? '').toString();
      _phoneController.text = (vetData['telefono'] ?? '').toString();
      _professionalIdController.text =
          (vetData['cedulaProfesional'] ?? '').toString();
      _clinicNameController.text = (vetData['clinica'] ?? '').toString();

      final spec = vetData['especialidad']?.toString();
      if (spec != null && specialties.contains(spec)) {
        _selectedSpecialty = spec;
      } else {
        _selectedSpecialty = spec;
      }

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar perfil: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<String> _uploadImage(String uid) async {
    if (_image == null) return _currentPhotoUrl ?? '';

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('$uid.jpg');

    await storageRef.putFile(_image!);
    return await storageRef.getDownloadURL();
  }

  Future<void> _save() async {
    if (_uid == null) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final photoUrl = await _uploadImage(_uid!);

      await _firestoreService.updateVeterinarianData(_uid!, {
        'nombreCompleto': _nameController.text.trim(),
        'telefono': _phoneController.text.trim(),
        'cedulaProfesional': _professionalIdController.text.trim(),
        'clinica': _clinicNameController.text.trim(),
        'especialidad': _selectedSpecialty,
        if (photoUrl.isNotEmpty) 'fotoUrl': photoUrl,
        'actualizadoEn': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado correctamente.'),
          backgroundColor: Color.fromRGBO(34, 139, 34, 1),
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar perfil: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Perfil - Veterinario'),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : (_currentPhotoUrl != null &&
                                          _currentPhotoUrl!.isNotEmpty)
                                      ? NetworkImage(_currentPhotoUrl!)
                                      : null,
                              child: (_image == null &&
                                      (_currentPhotoUrl == null ||
                                          _currentPhotoUrl!.isEmpty))
                                  ? const Icon(Icons.camera_alt, size: 40)
                                  : null,
                            ),
                            TextButton(
                              onPressed: _pickImage,
                              child: const Text('Cambiar foto'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Información del Veterinario',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre Completo',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El nombre es requerido';
                          }
                          if (value.length < 3) {
                            return 'El nombre debe tener al menos 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El teléfono es requerido';
                          }
                          if (value.length < 7) {
                            return 'Ingrese un número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _professionalIdController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Número de Cédula Profesional',
                          prefixIcon: Icon(Icons.badge),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La cédula profesional es requerida';
                          }
                          if (value.length < 6) {
                            return 'Ingrese un número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _clinicNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de Clínica/Consultorio',
                          prefixIcon: Icon(Icons.local_hospital),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El nombre de la clínica es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _selectedSpecialty,
                        decoration: const InputDecoration(
                          labelText: 'Especialidad',
                          prefixIcon: Icon(Icons.medical_services),
                        ),
                        items: specialties.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() => _selectedSpecialty = newValue);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleccione su especialidad';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Guardar cambios',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

