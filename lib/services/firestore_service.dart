import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrovet/models/user.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crear usuario (Ganadero o Veterinario)
  Future<void> createUser(String uid, String email, String name, String role) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'name': name,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }

  // Obtener usuario por UID
  Future<User?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return User(
          id: uid,
          email: data['email'] ?? '',
          password: '', // No se almacena la contraseña
          role: data['role'] == 'UserRole.veterinarian' 
              ? UserRole.veterinarian 
              : UserRole.farmer,
          name: data['name'] ?? '',
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }

  // Guardar datos del ganadero
  Future<void> saveFarmerData(String uid, Map<String, dynamic> farmerData) async {
    try {
      await _firestore.collection('farmers').doc(uid).set({
        ...farmerData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al guardar datos del ganadero: $e');
    }
  }

  // Guardar datos del veterinario
  Future<void> saveVeterinarianData(String uid, Map<String, dynamic> vetData) async {
    try {
      await _firestore.collection('veterinarians').doc(uid).set({
        ...vetData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al guardar datos del veterinario: $e');
    }
  }

  // Obtener datos del ganadero
  Future<Map<String, dynamic>?> getFarmerData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('farmers').doc(uid).get();
      
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener datos del ganadero: $e');
    }
  }

  // Obtener datos del veterinario
  Future<Map<String, dynamic>?> getVeterinarianData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('veterinarians').doc(uid).get();
      
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener datos del veterinario: $e');
    }
  }

  // Obtener todos los veterinarios
  Future<List<Map<String, dynamic>>> getAllVeterinarians() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('veterinarians').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Error al obtener veterinarios: $e');
    }
  }

  // Buscar ganaderos por vereda
  Future<List<Map<String, dynamic>>> searchFarmersByVereda(String vereda) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('farmers')
          .where('vereda', isEqualTo: vereda)
          .get();
      
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Error al buscar ganaderos: $e');
    }
  }
}
