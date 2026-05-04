enum AppointmentType {
  consultation,
  vaccination,
  deworming,
  surgery,
  checkup,
}

class Appointment {
  final String id;
  final String animalId;
  final String animalName;
  final String veterinarianName;
  final AppointmentType type;
  final DateTime dateTime;
  final String notes;
  final bool completed;

  Appointment({
    required this.id,
    required this.animalId,
    required this.animalName,
    required this.veterinarianName,
    required this.type,
    required this.dateTime,
    required this.notes,
    required this.completed,
  });

  String get typeName {
    switch (type) {
      case AppointmentType.consultation:
        return 'Consulta general';
      case AppointmentType.vaccination:
        return 'Control vacuna';
      case AppointmentType.deworming:
        return 'Desparasitación';
      case AppointmentType.surgery:
        return 'Cirugía';
      case AppointmentType.checkup:
        return 'Revisión';
    }
  }

  String get formattedTime {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDate {
    final months = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return '${months[dateTime.month]} ${dateTime.day}';
  }
}
