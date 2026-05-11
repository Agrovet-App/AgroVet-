import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agrovet/utils/app_theme.dart';
import 'package:agrovet/models/user.dart';

class AccountTypeSelectionScreen extends StatelessWidget {
  final String action; // 'login' o 'register'

  const AccountTypeSelectionScreen({
    super.key,
    required this.action,
  });

  void _selectRole(BuildContext context, UserRole role) {
    String route = '';
    
    if (action == 'login') {
      route = role == UserRole.veterinarian ? '/login_veterinarian' : '/login_farmer';
    } else {
      route = role == UserRole.veterinarian ? '/register_veterinarian' : '/register_farmer';
    }
    
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final String title = action == 'login' ? 'Iniciar Sesión' : 'Crear Cuenta';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                
                // Title
                const Text(
                  '¿Qué tipo de cuenta eres?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 48),

                // Veterinarian Card
                _buildRoleCard(
                  context,
                  icon: FontAwesomeIcons.stethoscope,
                  title: 'Veterinario',
                  description: 'Acceso profesional veterinario',
                  role: UserRole.veterinarian,
                ),
                const SizedBox(height: 24),

                // Farmer/Ganadero Card
                _buildRoleCard(
                  context,
                  icon: FontAwesomeIcons.leaf,
                  title: 'Ganadero',
                  description: 'Acceso para ganaderos y productores',
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _selectRole(context, role),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              FaIcon(
                icon,
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.gray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
