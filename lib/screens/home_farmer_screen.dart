import 'package:flutter/material.dart';
import 'package:agrovet/utils/app_theme.dart';
import 'package:agrovet/services/auth_service.dart';
import 'package:agrovet/services/firestore_service.dart';
import 'package:agrovet/screens/chat_screen.dart';

class HomeFarmerScreen extends StatefulWidget {
  const HomeFarmerScreen({super.key});

  @override
  State<HomeFarmerScreen> createState() => _HomeFarmerScreenState();
}

class _HomeFarmerScreenState extends State<HomeFarmerScreen> {
  int _currentIndex = 0;
  late final AuthService _authService;
  late final FirestoreService _firestoreService;
  late String _farmerId;

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
      _farmerId = '';
    } else {
      _farmerId = currentUser.uid;
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _buildHomeView(),      // Pantalla de Inicio
      _buildAgendaView(),    // Citas
      _buildChatsView(),     // Chats
      _buildCattleView(),    // Ganado
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            _getAppBarTitle(_currentIndex),
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        actions: [
          if (_currentIndex == 3)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF3A736A),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, '/register_animal'),
                ),
              ),
            ),
          if (_currentIndex == 1)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF3A736A),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, '/manage_appointment'),
                ),
              ),
            ),
        ],
      ),
      
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF3A736A),
        unselectedItemColor: Colors.grey.shade400,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Citas'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.pets_outlined), label: 'Ganado'),
        ],
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Resumen General';
      case 1:
        return 'Mis Citas';
      case 2:
        return 'Mensajes';
      case 3:
        return 'Mi Ganado';
      default:
        return 'AgroVet';
    }
  }

  // --- NUEVA VISTA DE INICIO ---
  Widget _buildHomeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "¡Hola de nuevo!",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          const Text(
            "Gestiona tu granja con rapidez y claridad.",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.22),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumen rápido',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tu granja siempre a la vista',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                Row(
                  children: const [
                    Icon(Icons.health_and_safety, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Revisa tu ganado y recibe notificaciones de citas en un solo lugar.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSummaryCards(),
          const SizedBox(height: 26),
          _buildSectionHeader('Acciones rápidas', 'Encuentra lo que necesitas en un toque'),
          const SizedBox(height: 16),
          _buildActionCard(
            title: "Citas Pendientes",
            subtitle: "Revisa tus próximas visitas con el veterinario",
            icon: Icons.assignment_outlined,
            color: Colors.blue.shade400,
            onTap: () => _onTabTapped(1),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            title: "Contactar Veterinario",
            subtitle: "Envía un mensaje rápido a tu especialista",
            icon: Icons.chat_bubble_outline,
            color: Colors.orange.shade400,
            onTap: () => _onTabTapped(2),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return FutureBuilder<List<List<Map<String, dynamic>>>>(
      future: Future.wait<List<Map<String, dynamic>>>([
        _firestoreService.getFarmerAnimals(_farmerId),
        _firestoreService.getFarmerAppointments(_farmerId),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            children: [
              Expanded(child: _buildLoadingStatCard()),
              const SizedBox(width: 12),
              Expanded(child: _buildLoadingStatCard()),
            ],
          );
        }

        final animals = snapshot.data?[0] ?? <Map<String, dynamic>>[];
        final appointments = snapshot.data?[1] ?? <Map<String, dynamic>>[];

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'Animales',
                value: animals.length.toString(),
                icon: Icons.pets,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                label: 'Citas',
                value: appointments.length.toString(),
                icon: Icons.calendar_today,
                color: AppColors.accent,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            'Nuevo',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingStatCard() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  // Widget para crear los botones de acción del Inicio
  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withOpacity(0.04)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // --- VISTA DE CITAS - Datos reales de la BD ---
  Widget _buildAgendaView() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _firestoreService.getFarmerAppointments(_farmerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text(
                  'No hay citas registradas',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/manage_appointment'),
                  icon: const Icon(Icons.add),
                  label: const Text('Agendar Cita'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A736A),
                  ),
                ),
              ],
            ),
          );
        }

        final appointments = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCalendarSection(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PRÓXIMAS CITAS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/manage_appointment'),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Nueva Cita'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...appointments.map((appointment) {
                return _buildAppointmentCardFromData(appointment);
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppointmentCardFromData(Map<String, dynamic> appointment) {
    final DateTime? fecha = (appointment['fecha'] as dynamic)?.toDate() ?? DateTime.now();
    final String titulo = appointment['servicio'] ?? 'Cita';
    final String animal = appointment['animal'] ?? 'Animal';
    final String hora = appointment['hora'] ?? 'Hora no especificada';
    final String vetNombre = appointment['veterinarioNombre'] ?? 'Veterinario';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _showAppointmentDetails(context, appointment),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A736A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          (fecha?.day ?? 1).toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A736A),
                          ),
                        ),
                        Text(
                          _getMonthName(fecha?.month ?? 1),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF3A736A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          animal,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    hora,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      vetNombre,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'ENE',
      'FEB',
      'MAR',
      'ABR',
      'MAY',
      'JUN',
      'JUL',
      'AGO',
      'SEP',
      'OCT',
      'NOV',
      'DIC'
    ];
    return months[month - 1];
  }

  Widget _buildCalendarSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: const Column(
        children: [
          Text('Marzo 2026', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("L  M  M  J  V  S  D\n1  2  3  4  5  6  7", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // --- VISTA DE CHATS ---
  Widget _buildChatsView() {
    // Para el ganadero: poder chatear con veterinarios existentes.
    return ChatScreen(userId: _farmerId);
  }




  // --- VISTA DE GANADO ---
  Widget _buildCattleView() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _firestoreService.getFarmerAnimals(_farmerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final animals = snapshot.data ?? [];

        if (animals.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pets_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text(
                  'No hay animales registrados',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/register_animal'),
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Animal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A736A),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: animals.length,
          itemBuilder: (context, index) {
            final animal = animals[index];
            return _buildAnimalCard(animal, index);
          },
        );
      },
    );
  }

  void _showAnimalDetails(BuildContext context, Map<String, dynamic> animal) {
    final String nombre = animal['nombre'] ?? 'Animal sin nombre';
    final String especie = animal['especie'] ?? 'Desconocida';
    final String raza = animal['raza'] ?? 'N/A';
    final String edad = animal['edad']?.toString() ?? '0';
    final String peso = animal['peso']?.toString() ?? 'N/A';
    final String sexo = animal['sexo'] ?? 'Desconocido';
    final String notas = animal['notasMedicas'] ?? 'Sin notas adicionales';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.58,
            minChildSize: 0.3,
            maxChildSize: 0.88,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  24 + MediaQuery.of(context).viewPadding.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      nombre,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$especie • $raza',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _detailChip('Edad', '$edad años'),
                        const SizedBox(width: 10),
                        _detailChip('Sexo', sexo),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _detailChip('Peso', '$peso kg'),
                        const SizedBox(width: 10),
                        _detailChip('Raza', raza),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Notas médicas',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notas,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A736A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Cerrar'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _detailChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context, Map<String, dynamic> appointment) {
    final DateTime fecha = (appointment['fecha'] as dynamic)?.toDate() ?? DateTime.now();
    final String titulo = appointment['servicio'] ?? 'Cita';
    final String animal = appointment['animal'] ?? 'Animal';
    final String hora = appointment['hora'] ?? 'Hora no especificada';
    final String vetNombre = appointment['veterinarioNombre'] ?? 'Veterinario';
    final String notas = appointment['notas'] ?? appointment['descripcion'] ?? 'Sin notas adicionales';
    final String estado = appointment['estado'] ?? 'pendiente';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.52,
          minChildSize: 0.38,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const Text(
                      'Detalle de la cita',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      titulo,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Estado: ${estado.toUpperCase()}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _detailChip('Animal', animal),
                        const SizedBox(width: 12),
                        _detailChip('Veterinario', vetNombre),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _detailChip('Fecha', '${fecha.day}/${fecha.month}/${fecha.year}'),
                        const SizedBox(width: 12),
                        _detailChip('Hora', hora),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Notas',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      notas,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A736A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAnimalCard(Map<String, dynamic> animal, int index) {
    final String nombre = animal['nombre'] ?? 'Animal ${index + 1}';
    final String especie = animal['especie'] ?? 'Desconocida';
    final String raza = animal['raza'] ?? 'N/A';
    final String edad = animal['edad']?.toString() ?? '0';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _showAnimalDetails(context, animal),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A736A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  especie.toLowerCase() == 'vaca' ? Icons.pets : Icons.agriculture,
                  color: const Color(0xFF3A736A),
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$especie • $raza',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Edad: $edad años',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}