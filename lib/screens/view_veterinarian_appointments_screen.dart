import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrovet/services/auth_service.dart';
import 'package:agrovet/services/firestore_service.dart';
import 'package:agrovet/utils/app_theme.dart';


class ViewVeterinarianAppointmentsScreen extends StatefulWidget {
  const ViewVeterinarianAppointmentsScreen({super.key});

  @override
  State<ViewVeterinarianAppointmentsScreen> createState() =>
      _ViewVeterinarianAppointmentsScreenState();
}

class _ViewVeterinarianAppointmentsScreenState
    extends State<ViewVeterinarianAppointmentsScreen> {
  late final AuthService _authService;
  late final FirestoreService _firestoreService;
  String? _veterinarianId;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _firestoreService = FirestoreService();

    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      _veterinarianId = currentUser.uid;
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
          'Ver citas',
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_veterinarianId == null || _veterinarianId!.isEmpty) {
      return const Center(
        child: Text(
          'No hay veterinario logueado',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _firestoreService.getVeterinarianAppointments(_veterinarianId!),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error al cargar citas: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        final appointments = (snapshot.data ?? [])
          ..sort((a, b) {
            final fechaA = a['fecha'] as dynamic;
            final fechaB = b['fecha'] as dynamic;

            final DateTime? dateA = (fechaA is Timestamp)
                ? fechaA.toDate()
                : (fechaA is DateTime ? fechaA : null);
            final DateTime? dateB = (fechaB is Timestamp)
                ? fechaB.toDate()
                : (fechaB is DateTime ? fechaB : null);

            final safeA = dateA ?? DateTime.fromMillisecondsSinceEpoch(0);
            final safeB = dateB ?? DateTime.fromMillisecondsSinceEpoch(0);
            return safeB.compareTo(safeA);
          });

        if (appointments.isEmpty) {

          return const Center(
            child: Text(
              'No tienes citas registradas',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.separated(
          itemCount: appointments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final apt = appointments[index];
            return _AppointmentCard(data: apt);
          },
        );
      },
    );
  }
}

class _AppointmentCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const _AppointmentCard({required this.data});

  @override
  State<_AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<_AppointmentCard> {
  static const List<String> _estados = [
    'pendiente',
    'en_progreso',
    'completada',
    'cancelada',
  ];

  late String _estado;

  @override
  void initState() {
    super.initState();
    _estado = (widget.data['estado'] ?? 'pendiente').toString();
  }

  Future<void> _updateEstado(String nuevoEstado) async {
    final firestoreService = FirestoreService();
    final appointmentId = (widget.data['id'] ?? '').toString();
    if (appointmentId.isEmpty) return;

    await firestoreService.updateAppointmentEstado(appointmentId, nuevoEstado);
    if (!mounted) return;
    setState(() => _estado = nuevoEstado);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final DateTime fecha = (data['fecha'] as dynamic)?.toDate() ?? DateTime.now();
    final String titulo = (data['servicio'] ?? 'Cita').toString();
    final String animal = (data['animal'] ?? 'Animal').toString();
    final String hora = (data['hora'] ?? '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}')
        .toString();
    final String notas = (data['notas'] ?? data['descripcion'] ?? '').toString().trim();

    return Container(

      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray50, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${fecha.day}/${fecha.month}/${fecha.year}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _estado,
                    isDense: true,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                    items: _estados.map((e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (nuevo) {
                      if (nuevo == null || nuevo == _estado) return;
                      _updateEstado(nuevo);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '🐾 $animal',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          if (notas.isNotEmpty) ...[
            Text(
              'Descripción: $notas',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              const Icon(Icons.schedule, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                hora,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

