import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agrovet/utils/app_theme.dart';
import 'package:agrovet/models/appointment.dart';

class ManageAppointmentsScreen extends StatefulWidget {
  const ManageAppointmentsScreen({super.key});

  @override
  State<ManageAppointmentsScreen> createState() =>
      _ManageAppointmentsScreenState();
}

class _ManageAppointmentsScreenState extends State<ManageAppointmentsScreen> {
  late DateTime _selectedDate;
  final List<Appointment> _appointments = [
    Appointment(
      id: '1',
      animalId: '001',
      animalName: 'Rocky',
      veterinarianName: 'Dra. Laura Ruiz',
      type: AppointmentType.consultation,
      dateTime: DateTime(2026, 3, 5, 15, 0),
      notes: 'Revisión general',
      completed: false,
    ),
    Appointment(
      id: '2',
      animalId: '002',
      animalName: 'Luna',
      veterinarianName: 'Dr. Andrés Mora',
      type: AppointmentType.vaccination,
      dateTime: DateTime(2026, 3, 6, 10, 30),
      notes: 'Vacuna anual',
      completed: false,
    ),
    Appointment(
      id: '3',
      animalId: '003',
      animalName: 'Toro',
      veterinarianName: 'Dra. Laura Ruiz',
      type: AppointmentType.deworming,
      dateTime: DateTime(2026, 3, 11, 14, 0),
      notes: 'Desparasitación',
      completed: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(2026, 3, 5);
  }

  List<Appointment> get _upcomingAppointments {
    return _appointments.where((apt) => !apt.completed).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Citas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendario
              _buildCalendar(),
              const SizedBox(height: 32),

              // Próximas citas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PRÓXIMAS CITAS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.plus,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Lista de citas
              ..._upcomingAppointments.map((appointment) {
                return _buildAppointmentCard(appointment);
              }).toList(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Ubicación',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Animales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Más',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final firstDay = DateTime(2026, 3, 1);
    final lastDay = DateTime(2026, 3, 31);
    final daysInMonth = (lastDay.day).toInt();

    // Calcular en qué día de la semana empieza el mes
    final dayOfWeek = firstDay.weekday; // 1 = Monday, 7 = Sunday

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gray50,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con mes y navegación
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Marzo 2026',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Días de la semana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text('L', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('M', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('M', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('J', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('V', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('S', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('D', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),

          // Cuadrícula de días
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.2,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42, // 7 columnas x 6 filas
            itemBuilder: (context, index) {
              final dayNum = index - (dayOfWeek - 1) + 1;

              if (dayNum < 1 || dayNum > daysInMonth) {
                return const SizedBox();
              }

              final isSelected = dayNum == _selectedDate.day;
              final hasAppointment = _upcomingAppointments.any(
                (apt) => apt.dateTime.day == dayNum,
              );

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = DateTime(2026, 3, dayNum);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$dayNum',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.black,
                        ),
                      ),
                      if (hasAppointment)
                        Positioned(
                          bottom: 4,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final typeColors = {
      AppointmentType.consultation: Colors.teal,
      AppointmentType.vaccination: Colors.orange,
      AppointmentType.deworming: Colors.purple,
      AppointmentType.surgery: Colors.red,
      AppointmentType.checkup: Colors.blue,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (typeColors[appointment.type] ?? Colors.blue)
              .withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Fecha
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (typeColors[appointment.type] ?? Colors.blue)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  appointment.formattedDate.split(' ')[0],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray,
                  ),
                ),
                Text(
                  appointment.formattedDate.split(' ')[1],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: typeColors[appointment.type],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Detalles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.typeName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '🐾 ${appointment.animalName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray,
                  ),
                ),
                Text(
                  '👨‍⚕️ ${appointment.veterinarianName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),

          // Hora
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              appointment.formattedTime,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
