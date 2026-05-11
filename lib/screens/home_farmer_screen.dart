import 'package:flutter/material.dart';

class HomeFarmerScreen extends StatefulWidget {
  const HomeFarmerScreen({super.key});

  @override
  State<HomeFarmerScreen> createState() => _HomeFarmerScreenState();
}

class _HomeFarmerScreenState extends State<HomeFarmerScreen> {
  int _currentIndex = 0; 

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _buildHomeView(),   // Pantalla de Inicio renovada
      _buildAgendaView(), // Citas
      const Center(child: Text('Pantalla de Chats', style: TextStyle(fontSize: 20))),
      const Center(child: Text('Pantalla de Ganado', style: TextStyle(fontSize: 20))),
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
            _currentIndex == 0 ? 'Resumen General' : (_currentIndex == 1 ? 'Mis Citas' : 'AgroVet'),
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        actions: [
          if (_currentIndex == 1) 
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF3A736A),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, '/my_farm'),
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
          const SizedBox(height: 20),

          // Tarjeta de Total de Ganado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF3A736A), // Verde institucional
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3A736A).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total de ganado",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "45 Animales",
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pets, color: Colors.white, size: 30),
                )
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Sección de Veterinario
          const Text(
            "SERVICIOS VETERINARIOS",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
          ),
          const SizedBox(height: 16),

          // Botón 1: Citas Pendientes
          _buildActionCard(
            title: "Citas Pendientes",
            subtitle: "Tienes 2 para esta semana",
            icon: Icons.assignment_outlined,
            color: Colors.blue.shade400,
            onTap: () => _onTabTapped(1), // Salta a la pestaña de Citas
          ),

          const SizedBox(height: 16),

          // Botón 2: Comunicación con Veterinario
          _buildActionCard(
            title: "Contactar Veterinario",
            subtitle: "Chat directo con un experto",
            icon: Icons.chat_bubble_outline,
            color: Colors.orange.shade400,
            onTap: () => _onTabTapped(2), // Salta a la pestaña de Chat
          ),
        ],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color),
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
    );
  }

  // --- VISTA DE CITAS (Ya la tienes diseñada) ---
  Widget _buildAgendaView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendarSection(),
          const SizedBox(height: 24),
          const Text('PRÓXIMAS CITAS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          _buildAppointmentCard('5', 'MAR', 'Consulta general', 'Estrella - 3:00 PM', true),
          _buildAppointmentCard('6', 'MAR', 'Control vacuna', 'Nube - 10:30 AM', false, Icons.vaccines),
        ],
      ),
    );
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

  Widget _buildAppointmentCard(String day, String month, String title, String sub, bool today, [IconData? icon]) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Column(children: [Text(month, style: const TextStyle(fontSize: 10, color: Color(0xFF3A736A))), Text(day, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]),
          const SizedBox(width: 20),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12))])),
          if (icon != null) Icon(icon, color: Colors.blue.shade100),
        ],
      ),
    );
  }
}