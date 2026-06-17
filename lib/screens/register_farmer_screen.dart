import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:agrovet/utils/app_theme.dart';
import 'package:agrovet/utils/validators.dart';
import 'package:agrovet/services/auth_service.dart';
import 'package:agrovet/services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterFarmerScreen extends StatefulWidget {

  const RegisterFarmerScreen({super.key});

  @override
  State<RegisterFarmerScreen> createState() => _RegisterFarmerScreenState();
}

class _RegisterFarmerScreenState extends State<RegisterFarmerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();
  final _veredaController = TextEditingController();
  final _yearsController = TextEditingController();
  final _predioDiameterController = TextEditingController();

  String? _selectedSex;
  String? _selectedEducation;
  bool _isLoading = false;

  final sexOptions = ['Masculino', 'Femenino', 'Prefiero no responder'];
  final educationOptions = [
    'Ninguno',
    'Primaria incompleta',
    'Primaria completa',
    'Secundaria incompleta',
    'Secundaria completa',
    'Técnico/Tecnológico',
    'Universitario'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    _veredaController.dispose();
    _yearsController.dispose();
    _predioDiameterController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(String uid) async {
    // En web y algunos targets, firebase_storage + putFile puede fallar con
    // errores tipo "Unsupported operation: _Namespace".
    // Para que el registro funcione igual, omitimos el upload.
    if (kIsWeb) return '';

    if (_image == null) return '';

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('$uid.jpg');

    await storageRef.putFile(_image!);

    return await storageRef.getDownloadURL();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    debugPrint('RegisterFarmerScreen: starting _register()');

    try {
      // Crear usuario en Firebase Auth
      final user = await _authService.registerWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        // Crear registro en colección 'users'
        await _firestoreService.createUser(
          user.uid,
          _emailController.text.trim(),
          _nameController.text.trim(),
          'ganadero',
          '', // telefono (opcional)
        );

        final photoUrl = await _uploadImage(user.uid);

        // Verificar que 'users/{uid}' ya existe y tiene rol='ganadero' antes de escribir en 'ganaderos/{uid}'
        // (por reglas de Firestore).
        final uid = user.uid;
        final myUserDoc = await _firestoreService.getUserById(uid);
        final userRole = myUserDoc?.rol;

        if (userRole != 'ganadero') {
          throw Exception(
            'No se pudo completar el registro del ganadero: el documento users/$uid aún no está listo o no tiene rol="ganadero" (rol=${userRole ?? 'null'}).',
          );
        }

        // Guardar datos del ganadero en 'ganaderos'
        await _firestoreService.saveFarmerData(uid, {
          'nombreCompleto': _nameController.text.trim(),
          'correo': _emailController.text.trim(),
          'telefono': _phoneController.text.trim(),
          'documento': '',
          'edad': int.parse(_ageController.text),
          'sexo': _selectedSex,
          'nivelEducativo': _selectedEducation,
          'vereda': _veredaController.text.trim(),
          'anosActividadPecuaria': int.parse(_yearsController.text),
          'tamanoPredio': double.parse(_predioDiameterController.text),
          'direccion': _addressController.text.trim(),
          'notas': '',
          'fotoUrl': photoUrl,
          'cantidadAnimales': 0,
          'estadoSanitario': 'estable',
        });


        if (!mounted) return;

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Registro exitoso!'),
            backgroundColor: Color.fromRGBO(34, 139, 34, 1),
          ),
        );

        // Ir a pantalla de inicio del ganadero
        Navigator.of(context).pushReplacementNamed('/home_farmer');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Mostrar más detalle del error de Firebase Auth.
      // Esto ayuda a identificar la causa exacta del 400 (weak-password,
      // email-already-in-use, invalid-email, etc.).
      final msg = (() {
        try {
          return 'Error: ${e.toString()}';
        } catch (_) {
          return 'Error desconocido';
        }
      })();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // En web, evitar FileImage/decodificación desde File (crashea con _Namespace).
    final bool canRenderLocalImage = !kIsWeb;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro - Ganadero'),
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
                        'Información Sociodemográfica',
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
                              backgroundImage:
                            (!kIsWeb && _image != null) ? FileImage(_image!) : null,
                              child: _image == null
                                  ? const Icon(
                                      Icons.camera_alt,
                                      size: 42,
                                      color: AppColors.primary,
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            const SizedBox.shrink(),
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
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Edad (años)',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La edad es requerida';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Ingrese un número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedSex,
                        decoration: const InputDecoration(
                          labelText: 'Sexo',
                          prefixIcon: Icon(Icons.person),
                        ),
                        items: sexOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSex = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleccione su sexo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedEducation,
                        decoration: const InputDecoration(
                          labelText: 'Nivel educativo',
                          prefixIcon: Icon(Icons.school),
                        ),
                        items: educationOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedEducation = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleccione su nivel educativo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _veredaController,
                        decoration: const InputDecoration(
                          labelText: 'Vereda',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La vereda es requerida';
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
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                          prefixIcon: Icon(Icons.home),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La dirección es requerida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _yearsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Años en actividad pecuaria',
                          prefixIcon: Icon(Icons.timer),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es requerido';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Ingrese un número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _predioDiameterController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tamaño del predio (hectáreas)',
                          prefixIcon: Icon(Icons.agriculture),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El tamaño del predio es requerido';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Ingrese un número válido';
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
