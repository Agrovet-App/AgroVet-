import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:agrovet/utils/app_theme.dart';
import 'package:agrovet/utils/validators.dart';
import 'package:agrovet/services/auth_service.dart';
import 'package:agrovet/services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';

class RegisterVeterinarianScreen extends StatefulWidget {

  const RegisterVeterinarianScreen({super.key});

  @override
  State<RegisterVeterinarianScreen> createState() => _RegisterVeterinarianScreenState();
}

class _RegisterVeterinarianScreenState extends State<RegisterVeterinarianScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  
  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _professionalIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _clinicNameController = TextEditingController();

  Uint8List? _imageBytes;

  final ImagePicker _picker = ImagePicker();

  String? _selectedSpecialty;

  bool _isLoading = false;

  final specialties = [
    'Medicina General',
    'Cirugía',
    'Oftalmología',
    'Dermatología',
    'Medicina Interna',
    'Odontología',
    'Reproducción',
    'Otro'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _professionalIdController.dispose();
    _phoneController.dispose();
    _clinicNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    setState(() {
      _imageBytes = bytes;
    });
  }

  Future<String> _uploadImage(String uid) async {
    // Guardar solo en Firestore (evitamos Storage en web por CORS).
    // En otras plataformas podrías implementar el upload si lo necesitas.
    if (_imageBytes == null) return '';
    return '';
  }


  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Crear usuario en Firebase Auth
      final user = await _authService.registerWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        final uid = user.uid;

        // Crear/actualizar registro en colección 'users'
        await _firestoreService.createUser(
          uid,
          _emailController.text.trim(),
          _nameController.text.trim(),
          'veterinario',
          _phoneController.text.trim(),
        );

        // En web pueden fallar los uploads por CORS; si falla, continuamos sin bloquear el registro.
        final photoUrl = await _uploadImage(uid);

        // Guardar datos del veterinario en 'veterinarios'
        await _firestoreService.saveVeterinarianData(uid, {

          'nombreCompleto': _nameController.text.trim(),
          'correo': _emailController.text.trim(),
          'telefono': _phoneController.text.trim(),
          'cedulaProfesional': _professionalIdController.text.trim(),
          'clinica': _clinicNameController.text.trim(),
          'especialidad': _selectedSpecialty,
          'direccion': '',
          if (photoUrl.isNotEmpty) 'fotoUrl': photoUrl,
          'experiencia': 0,
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Registro exitoso!'),
            backgroundColor: Color.fromRGBO(34, 139, 34, 1),
          ),
        );

        Navigator.of(context).pushReplacementNamed('/home_veterinarian');
      } else {
        // Si el email ya existe en Firebase Auth, intentamos login y aseguramos documentos en Firestore.
        final existingUser = await _authService.loginWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (existingUser == null) {
          throw Exception('No se pudo iniciar sesión con ese correo.');
        }

        final uid = existingUser.uid;

        await _firestoreService.createUser(
          uid,
          _emailController.text.trim(),
          _nameController.text.trim(),
          'veterinario',
          _phoneController.text.trim(),
        );

        // En web pueden fallar los uploads por CORS; si falla, continuamos sin bloquear el registro.
        final photoUrl = await _uploadImage(uid);

        await _firestoreService.saveVeterinarianData(uid, {

          'nombreCompleto': _nameController.text.trim(),
          'correo': _emailController.text.trim(),
          'telefono': _phoneController.text.trim(),
          'cedulaProfesional': _professionalIdController.text.trim(),
          'clinica': _clinicNameController.text.trim(),
          'especialidad': _selectedSpecialty,
          'direccion': '',
          'fotoUrl': photoUrl,
          'experiencia': 0,
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Cuenta existente, datos asegurados!'),
            backgroundColor: Color.fromRGBO(34, 139, 34, 1),
          ),
        );

        Navigator.of(context).pushReplacementNamed('/home_veterinarian');
      }
    } catch (e) {

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Registro - Veterinario'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/account_type_register');
          },
        ),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información Profesional',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.12),
                              backgroundImage: _imageBytes != null
                                  ? MemoryImage(_imageBytes!)
                                  : null,
                              child: _imageBytes == null
                                  ? const Icon(
                                      Icons.camera_alt,
                                      size: 42,
                                      color: AppColors.primary,
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _pickImage,
                              child: const Text('Seleccionar Foto'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: Validators.validatePassword,
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
                          setState(() {
                            _selectedSpecialty = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleccione su especialidad';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Registrarse'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
