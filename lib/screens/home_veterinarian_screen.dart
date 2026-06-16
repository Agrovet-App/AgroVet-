import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agrovet/utils/app_theme.dart';
import 'package:agrovet/screens/view_animals_screen.dart';
import 'package:agrovet/screens/manage_appointment_screen.dart';
import 'package:agrovet/screens/update_veterinarian_profile_screen.dart';
import 'package:agrovet/screens/view_veterinarian_appointments_screen.dart';
import 'package:agrovet/screens/veterinarian_chat_screen.dart';
import 'package:agrovet/services/auth_service.dart';





class HomeVeterinarianScreen extends StatelessWidget {
  const HomeVeterinarianScreen({super.key});

  String _getCurrentVeterinarianId() {
    // Usa el uid logueado.
    return AuthService().getCurrentUser()?.uid ?? '';
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AgroVet - Veterinario'),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryVariant],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Bienvenido Veterinario',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Accede rápido a tu agenda y animales registrados.',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Accesos rápidos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.05,
              children: [
                _buildMenuCard(
                  FontAwesomeIcons.paw,
                  'Animales',
                  AppColors.secondary,
                  'Ver Animales Registrados',
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ViewAnimalsScreen()),
                  ),
                ),
                _buildMenuCard(
                  FontAwesomeIcons.calendarCheck,
                  'Citas',
                  AppColors.primary,
                  'Gestionar citas',
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ManageAppointmentScreen()),
                  ),
                ),
                _buildMenuCard(
                  FontAwesomeIcons.userDoctor,
                  'Perfil',
                  AppColors.success,
                  'Actualizar perfil',
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const UpdateVeterinarianProfileScreen()),
                  ),
                ),
                _buildMenuCard(
                  FontAwesomeIcons.clipboardList,
                  'Agenda',
                  AppColors.danger,
                  'Ver citas asignadas',
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ViewVeterinarianAppointmentsScreen()),
                  ),
                ),
                _buildMenuCard(
                  FontAwesomeIcons.commentDots,
                  'Chats',
                  AppColors.primaryVariant,
                  'Chatea con ganaderos',
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VeterinarianChatScreen(
                        veterinarioId: _getCurrentVeterinarianId(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    FaIconData icon,
    String title,
    Color color,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FaIcon(icon, size: 28, color: color),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.darkGray, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
