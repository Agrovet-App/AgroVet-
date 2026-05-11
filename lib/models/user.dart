enum UserRole {
  veterinarian,
  farmer,
}

class User {
  final String uid;
  final String rol;
  final bool activo;
  final String nombreCompleto;
  final String correo;
  final String telefono;
  final String? fotoPerfil;
  final DateTime? creadoEn;
  final DateTime? actualizadoEn;

  User({
    required this.uid,
    required this.rol,
    required this.activo,
    required this.nombreCompleto,
    required this.correo,
    required this.telefono,
    this.fotoPerfil,
    this.creadoEn,
    this.actualizadoEn,
  });

  // Constructor desde JSON (Firestore)
  factory User.fromJson(Map<String, dynamic> json, String docId) {
    return User(
      uid: json['uid'] ?? docId,
      rol: json['rol'] ?? 'ganadero',
      activo: json['activo'] ?? true,
      nombreCompleto: json['nombreCompleto'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'] ?? '',
      fotoPerfil: json['fotoPerfil'],
      creadoEn: json['creadoEn'] != null ? (json['creadoEn'] as dynamic).toDate() : null,
      actualizadoEn: json['actualizadoEn'] != null ? (json['actualizadoEn'] as dynamic).toDate() : null,
    );
  }

  // Convertir a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'rol': rol,
      'activo': activo,
      'nombreCompleto': nombreCompleto,
      'correo': correo,
      'telefono': telefono,
      'fotoPerfil': fotoPerfil,
      'creadoEn': creadoEn,
      'actualizadoEn': actualizadoEn,
    };
  }

  String get roleName {
    return rol == 'veterinario' ? 'Veterinario' : 'Ganadero';
  }
}
