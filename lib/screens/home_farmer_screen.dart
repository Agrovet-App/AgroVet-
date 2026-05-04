import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agrovet/utils/app_theme.dart';

class HomeFarmerScreen extends StatelessWidget {
  const HomeFarmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AgroVet - Campesino',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bienvenida
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Bienvenido Campesino',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Gestiona tu producción agrícola',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sección: Animales
              const Text(
                'Gestión de Animales',
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
                children: [
                  _buildMenuCard(
                    FontAwesomeIcons.cow,
                    'Mi Ganadería',
                    Colors.brown,
                  ),
                  _buildMenuCard(
                    FontAwesomeIcons.heartPulse,
                    'Salud del Ganado',
                    Colors.red,
                  ),
                  _buildMenuCard(
                    FontAwesomeIcons.leaf,
                    'Alimentación',
                    Colors.orange,
                  ),
                  _buildMenuCard(
                    FontAwesomeIcons.baby,
                    'Reproducción',
                    Colors.pink,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sección: Cultivos
              const Text(
                'Gestión de Cultivos',
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
                children: [
                  _buildMenuCard(
                    FontAwesomeIcons.leaf,
                    'Mis Cultivos',
                    Colors.green,
                  ),
                  _buildMenuCard(
                    FontAwesomeIcons.droplet,
                    'Riego',
                    Colors.blue,
                  ),
                  _buildMenuCard(
                    FontAwesomeIcons.sun,
                    'Clima',
                    Colors.yellow,
                  ),
                  _buildMenuCard(
                    FontAwesomeIcons.bug,
                    'Plagas',
                    Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sección: Reportes
              const Text(
                'Información',
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
                children: [
                  _buildMenuCard(
                    FontAwesomeIcons.chartLine,
                    'Producción',
                    Colors.teal,
                  ),
                  _buildMenuCard(
                    FontAwesomeIcons.circleQuestion,
                    'Asesoría',
                    Colors.indigo,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(FaIconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
