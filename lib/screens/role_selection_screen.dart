import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agrovet/utils/app_theme.dart';
import 'package:agrovet/models/user.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _selectRole(BuildContext context, UserRole role) {
    String route = role == UserRole.veterinarian ? '/login_veterinarian' : '/login_farmer';
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                SizedBox(
                  height: 120,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Title
                const Text(
                  'Bienvenido a AgroVet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Subtitle
                const Text(
                  '¿Quién eres?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 48),

                // Veterinarian Card
                _buildRoleCard(
                  context,
                  icon: FontAwesomeIcons.stethoscope,
                  title: 'Veterinario',
                  description: 'Acceso para profesionales veterinarios',
                  role: UserRole.veterinarian,
                ),
                const SizedBox(height: 20),

                // Farmer Card
                _buildRoleCard(
                  context,
                  icon: FontAwesomeIcons.leaf,
                  title: 'Campesino',
                  description: 'Acceso para productores agrícolas',
                  role: UserRole.farmer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required FaIconData icon,
    required String title,
    required String description,
    required UserRole role,
  }) {
    return GestureDetector(
      onTap: () => _selectRole(context, role),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gray50,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FaIcon(
                icon,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
