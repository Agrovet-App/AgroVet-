enum UserRole {
  veterinarian,
  farmer,
}

class User {
  final String id;
  final String email;
  final String password;
  final UserRole role;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.role,
    required this.name,
  });

  String get roleName {
    return role == UserRole.veterinarian ? 'Veterinario' : 'Campesino';
  }
}
