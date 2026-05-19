import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registrar usuario con email y contraseña
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Si el email ya existe, permitir continuar intentando con login.
      // El mensaje original se maneja en RegisterVeterinarianScreen.
      if (e.code == 'email-already-in-use') {
        return null;
      }
      throw _handleAuthError(e);
    }
  }

  // Inicia sesión (reutilizable en flujos de registro)
  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }


  // Cerrar sesión
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  // Obtener usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Escuchar cambios de autenticación
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // Manejar errores de autenticación
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'El email ya está registrado';
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'invalid-email':
        return 'El email no es válido';
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}
