import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agrovet/services/firestore_service.dart';
import 'package:agrovet/utils/app_theme.dart';

class ViewAnimalsScreen extends StatefulWidget {
  const ViewAnimalsScreen({super.key});

  @override
  State<ViewAnimalsScreen> createState() => _ViewAnimalsScreenState();
}

class _ViewAnimalsScreenState extends State<ViewAnimalsScreen> {
  late final FirestoreService _firestoreService;
  List<Map<String, dynamic>> _animals = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService();
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    setState(() => _isLoading = true);
    try {
      final animals = await _firestoreService.getAllAnimals();
      
      // Cargar datos del ganadero para cada animal
      for (var animal in animals) {
        final ganaderoId = animal['ganaderoId'] ?? '';
        if (ganaderoId.isNotEmpty) {
          final farmerData = await _firestoreService.getFarmerDataByUid(ganaderoId);
          if (farmerData != null) {
            final name = farmerData['nombreCompleto'] ?? 'Ganadero desconocido';
            final phone = farmerData['telefono'] ?? 'N/A';
            final direccion = farmerData['direccion'] ?? 'N/A';
            
            animal['farmerName'] = name;
            animal['farmerPhone'] = phone;
            animal['farmerDireccion'] = direccion;
          } else {
            animal['farmerName'] = 'Ganadero desconocido';
            animal['farmerPhone'] = 'N/A';
            animal['farmerDireccion'] = 'N/A';
          }
        } else {
          animal['farmerName'] = 'Ganadero desconocido';
          animal['farmerPhone'] = 'N/A';
          animal['farmerDireccion'] = 'N/A';
        }
      }
      
      setState(() {
        _animals = animals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar animales: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animales Registrados',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAnimals,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Reintentar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : _animals.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.cow,
                            size: 80,
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No hay animales registrados',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadAnimals,
                      color: AppColors.primary,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _animals.length,
                        itemBuilder: (context, index) {
                          final animal = _animals[index];
                          return _buildAnimalCard(context, animal);
                        },
                      ),
                    ),
    );
  }

  Widget _buildAnimalCard(BuildContext context, Map<String, dynamic> animal) {
    final especie = animal['especie'] ?? 'Desconocida';
    final nombre = animal['nombre'] ?? 'Sin nombre';
    final edad = animal['edad'] ?? 0;
    final sexo = animal['sexo'] ?? 'Desconocido';
    final peso = animal['peso'] ?? 0.0;
    final raza = animal['raza'] ?? 'Desconocida';
    final farmerName = animal['farmerName'] ?? 'Ganadero desconocido';

    return GestureDetector(
      onTap: () {
        _showAnimalDetails(context, animal);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icono de animal
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: FaIcon(
                    _getAnimalIcon(especie),
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Información del animal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$especie • $raza',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Edad: $edad años • Peso: ${peso}kg',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 12,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Dueño: $farmerName',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Flecha
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAnimalDetails(BuildContext context, Map<String, dynamic> animal) {
    final especie = animal['especie'] ?? 'Desconocida';
    final nombre = animal['nombre'] ?? 'Sin nombre';
    final edad = animal['edad'] ?? 0;
    final sexo = animal['sexo'] ?? 'Desconocido';
    final peso = animal['peso'] ?? 0.0;
    final raza = animal['raza'] ?? 'Desconocida';
    final notasMedicas = animal['notasMedicas'] ?? 'Sin notas médicas';
    final ganaderoId = animal['ganaderoId'] ?? '';
    final estado = animal['estado'] ?? 'Activo';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.85,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombre,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            especie,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: FaIcon(
                          _getAnimalIcon(especie),
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Estado
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getStatusColor(estado).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 12,
                        color: _getStatusColor(estado),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Estado: ${estado[0].toUpperCase()}${estado.substring(1)}',
                        style: TextStyle(
                          color: _getStatusColor(estado),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Especificaciones
                const Text(
                  'Especificaciones',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow('Raza', raza),
                _buildDetailRow('Edad', '$edad años'),
                _buildDetailRow('Peso', '${peso}kg'),
                _buildDetailRow('Sexo', sexo),
                const SizedBox(height: 20),

                // Notas Médicas
                const Text(
                  'Notas Médicas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    notasMedicas,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Información del ganadero
                FutureBuilder<Map<String, dynamic>?>(
                  future: _firestoreService.getFarmerDataByUid(ganaderoId),
                  builder: (context, snapshot) {
                    String farmerName = animal['farmerName'] ?? 'Desconocido';
                    String farmerPhone = animal['farmerPhone'] ?? 'N/A';
                    String farmerDireccion = animal['farmerDireccion'] ?? 'N/A';

                    if (snapshot.hasData && snapshot.data != null) {
                      final farmerData = snapshot.data!;
                      farmerName = farmerData['nombreCompleto'] ?? farmerName;
                      farmerPhone = farmerData['telefono'] ?? farmerPhone;
                      farmerDireccion = farmerData['direccion'] ?? farmerDireccion;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información del Ganadero',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow('Nombre', farmerName),
                        _buildDetailRow('Dirección', farmerDireccion),
                        _buildDetailRow('Teléfono', farmerPhone),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),

                // Botón cerrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  FaIconData _getAnimalIcon(String especie) {
    switch (especie.toLowerCase()) {
      case 'vaca':
      case 'bovino':
        return FontAwesomeIcons.cow;
      case 'caballo':
        return FontAwesomeIcons.horse;
      case 'cerdo':
        return FontAwesomeIcons.piggyBank;
      case 'oveja':
        return FontAwesomeIcons.heart;
      case 'cabra':
        return FontAwesomeIcons.heart;
      case 'pollo':
        return FontAwesomeIcons.feather;
      default:
        return FontAwesomeIcons.paw;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
        return Colors.green;
      case 'inactivo':
        return Colors.grey;
      case 'enfermo':
        return Colors.orange;
      case 'cuarentena':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
