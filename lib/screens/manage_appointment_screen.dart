import 'package:flutter/material.dart';
import 'package:agrovet/services/auth_service.dart';
import 'package:agrovet/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class ManageAppointmentScreen extends StatefulWidget {
  const ManageAppointmentScreen({super.key});

  @override
  State<ManageAppointmentScreen> createState() =>
      _ManageAppointmentScreenState();
}

class _ManageAppointmentScreenState extends State<ManageAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  late final AuthService _authService;
  late final FirestoreService _firestoreService;

  String? _selectedFarmerId;
  String? _selectedVet;
  String? _selectedAnimal;
  String? _selectedService;
  String? _descripcion;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  List<Map<String, dynamic>> _vets = [];
  List<Map<String, dynamic>> _farmers = [];
  List<Map<String, dynamic>> _animals = [];

  final List<String> _services = [
    'Consulta General',
    'Vacunación',
    'Desparasitación',
    'Cirugía',
    'Odontología',
    'Revisión de Salud',
    'Medicación',
    'Otro',
  ];

  String? _getFarmerDisplayName(Map<String, dynamic> farmer) {
    final nombre = farmer['nombreCompleto']?.toString();
    if (nombre != null && nombre.isNotEmpty) return nombre;
    final correo = farmer['correo']?.toString();
    if (correo != null && correo.isNotEmpty) return correo;
    return farmer['uid']?.toString() ?? 'Ganadero';
  }

  String? _getVetDisplayName(Map<String, dynamic> vet) {
    final nombre = vet['nombreCompleto']?.toString();
    if (nombre != null && nombre.isNotEmpty) return nombre;
    final correo = vet['correo']?.toString();
    if (correo != null && correo.isNotEmpty) return correo;
    return vet['uid']?.toString() ?? 'Veterinario';
  }

  @override
  void initState() {
    super.initState();

    _authService = AuthService();
    _firestoreService = FirestoreService();

    final currentUser = _authService.getCurrentUser();

    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      });
      _selectedFarmerId = null;
    } else {
      _loadData();
      _setLoggedVeterinarian();
    }
  }

  Future<void> _setLoggedVeterinarian() async {
    final currentUser = _authService.getCurrentUser();
    if (currentUser == null) return;

    try {
      final vetDoc = await _firestoreService.getVeterinarianData(currentUser.uid);
      if (!mounted) return;

      final String? vetIdFromDoc = (vetDoc?['uid']?.toString()) ?? currentUser.uid;
      setState(() {
        _selectedVet = vetIdFromDoc;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _selectedVet = currentUser.uid;
      });
    }
  }

  Future<void> _loadData() async {
    try {
      final vets = await _firestoreService.getAllVeterinarians();
      final farmers = await _firestoreService.getAllFarmers();

      if (mounted) {
        setState(() {
          _vets = vets;
          _farmers = farmers;
          _animals = [];
          _selectedAnimal = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar datos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedVet == null ||
        _selectedAnimal == null ||
        _selectedService == null ||
        _selectedDate == null ||
        _selectedTime == null ||
        _descripcion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final appointmentId = const Uuid().v4();

      final appointmentDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final appointmentData = {
        'id': appointmentId,
        'ganaderoId': _selectedFarmerId,
        'veterinarioId': _selectedVet,
        'animal': _selectedAnimal,
        'servicio': _selectedService,
        'fecha': appointmentDateTime,
        'hora':
            '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
        'notas': _descripcion,
        'estado': 'pendiente',
      };

      await _firestoreService.createAppointment(appointmentId, appointmentData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Cita solicitada exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agendar cita: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Solicitar Cita',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ganadero',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: _selectedFarmerId,
                  decoration: InputDecoration(
                    hintText: 'Selecciona un ganadero',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  items: _farmers
                      .map<DropdownMenuItem<String>>((farmer) {
                    final farmerId = farmer['uid']?.toString() ?? '';
                    final displayName = _getFarmerDisplayName(farmer) ?? 'Ganadero';
                    return DropdownMenuItem<String>(
                      value: farmerId,
                      child: Text(displayName),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    setState(() {
                      _selectedFarmerId = value;
                      _animals = [];
                      _selectedAnimal = null;
                    });

                    if (value != null && value.isNotEmpty) {
                      final animals = await _firestoreService.getFarmerAnimals(value);
                      if (!mounted) return;
                      setState(() => _animals = animals);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona un ganadero';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Veterinario',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  initialValue: (() {
                    if (_selectedVet == null || _selectedVet!.isEmpty) return '';
                    final vet = _vets.cast<Map<String, dynamic>>().firstWhere(
                          (v) => (v['uid']?.toString() ?? v['id']?.toString() ?? '') ==
                              _selectedVet,
                          orElse: () => <String, dynamic>{},
                        );
                    return vet.isEmpty ? _selectedVet! : _getVetDisplayName(vet);
                  })(),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (_selectedVet == null || _selectedVet!.isEmpty) {
                      return 'Veterinario no disponible';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Animal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: _selectedAnimal,
                  decoration: InputDecoration(
                    hintText: 'Selecciona un animal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    prefixIcon: const Icon(Icons.pets),
                  ),
                  items: _animals
                      .map<DropdownMenuItem<String>>((animal) {
                    final animalName = animal['nombre']?.toString() ?? 'Animal';
                    return DropdownMenuItem<String>(
                      value: animalName,
                      child: Text(animalName),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedAnimal = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona un animal';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Tipo de Servicio',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: _selectedService,
                  decoration: InputDecoration(
                    hintText: 'Selecciona el servicio',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    prefixIcon: const Icon(Icons.medical_services),
                  ),
                  items: _services
                      .map<DropdownMenuItem<String>>((service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedService = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona un servicio';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Descripción de la cita',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Describe el problema o lo que necesitas del veterinario',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    prefixIcon: const Icon(Icons.description_outlined),
                  ),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Agrega una descripción';
                    if (v.length < 5) return 'La descripción es muy corta';
                    return null;
                  },
                  onChanged: (v) => _descripcion = v.trim(),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'Selecciona una fecha'
                                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: _selectTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedTime == null
                                ? 'Selecciona una hora'
                                : '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveAppointment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A736A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Solicitar Cita',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

