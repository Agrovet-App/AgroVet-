import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


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
      // Para depuración y para que el UI muestre el motivo exacto del fallo.
      if (e.code == 'email-already-in-use') {
        return null;
      }

      final details = 'Auth error (code=${e.code}): ${e.message}';
      throw Exception(details);
    } catch (e) {
      // Fallback por si falla algo de red/CORS u otra cosa no-FirebaseAuthException.
      throw Exception('Auth signUp failed: $e');
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

  // Sign in with Google (web + mobile)
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        UserCredential result = await _auth.signInWithPopup(provider);
        return result.user;
      } else {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? account = await googleSignIn.signIn();
        if (account == null) return null;
        final googleAuth = await account.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential result = await _auth.signInWithCredential(credential);
        return result.user;
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw Exception('Error en Google Sign-In: $e');
    }
  }

  // Sign in with Facebook (web + mobile)
  Future<User?> signInWithFacebook() async {
    try {
      if (kIsWeb) {
        final provider = FacebookAuthProvider();
        UserCredential result = await _auth.signInWithPopup(provider);
        return result.user;
      } else {
        final LoginResult loginResult = await FacebookAuth.instance.login();
        if (loginResult.status != LoginStatus.success) return null;
        final accessToken = loginResult.accessToken?.token;
        if (accessToken == null) return null;
        final credential = FacebookAuthProvider.credential(accessToken);
        UserCredential result = await _auth.signInWithCredential(credential);
        return result.user;
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw Exception('Error en Facebook Sign-In: $e');
    }
  }

  // Sign in with GitHub (web). Mobile requires extra OAuth handling in Firebase console.
  Future<User?> signInWithGitHub() async {
    try {
      if (kIsWeb) {
        final provider = OAuthProvider('github.com');
        UserCredential result = await _auth.signInWithPopup(provider);
        return result.user;
      } else {
        throw Exception('GitHub sign-in en móviles requiere configuración adicional en Firebase Console.');
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw Exception('Error en GitHub Sign-In: $e');
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
