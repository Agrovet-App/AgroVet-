import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrovet/models/user.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crear usuario en la colección 'users'
  Future<void> createUser(String uid, String email, String nombreCompleto, String rol, String telefono) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'rol': rol,
        'activo': true,
        'nombreCompleto': nombreCompleto,
        'correo': email,
        'telefono': telefono,
        'fotoPerfil': null,
        'creadoEn': FieldValue.serverTimestamp(),
        'actualizadoEn': FieldValue.serverTimestamp(),
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
        return User.fromJson(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }

  // Guardar datos del ganadero en 'ganaderos'
  Future<void> saveFarmerData(String uid, Map<String, dynamic> farmerData) async {
    try {
      // Agregar uid, creadoEn, actualizadoEn
      farmerData['uid'] = uid;
      farmerData['creadoEn'] = FieldValue.serverTimestamp();
      farmerData['actualizadoEn'] = FieldValue.serverTimestamp();
      
      await _firestore.collection('ganaderos').doc(uid).set(farmerData);
    } catch (e) {
      throw Exception('Error al guardar datos del ganadero: $e');
    }
  }

  // Guardar datos del veterinario en 'veterinarios'
  Future<void> saveVeterinarianData(String uid, Map<String, dynamic> vetData) async {
    try {
      // Agregar uid, creadoEn, actualizadoEn, campos por defecto
      vetData['uid'] = uid;
      vetData['verificado'] = false;
      vetData['activo'] = true;
      vetData['rating'] = 0;
      vetData['cantidadCitas'] = 0;
      vetData['creadoEn'] = FieldValue.serverTimestamp();
      vetData['actualizadoEn'] = FieldValue.serverTimestamp();
      
      await _firestore.collection('veterinarios').doc(uid).set(vetData);
    } catch (e) {
      throw Exception('Error al guardar datos del veterinario: $e');
    }
  }

  // Obtener datos del ganadero
  Future<Map<String, dynamic>?> getFarmerData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('ganaderos').doc(uid).get();
      
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
      DocumentSnapshot doc = await _firestore.collection('veterinarios').doc(uid).get();
      
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener datos del veterinario: $e');
    }
  }

  // Obtener todos los veterinarios activos y verificados
  Future<List<Map<String, dynamic>>> getAllVeterinarians() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('veterinarios')
          .where('activo', isEqualTo: true)
          .where('verificado', isEqualTo: true)
          .get();
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
          .collection('ganaderos')
          .where('vereda', isEqualTo: vereda)
          .get();
      
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Error al buscar ganaderos: $e');
    }
  }

  // Crear animal en 'animales'
  Future<void> createAnimal(String animalId, Map<String, dynamic> animalData) async {
    try {
      animalData['creadoEn'] = FieldValue.serverTimestamp();
      animalData['actualizadoEn'] = FieldValue.serverTimestamp();
      
      await _firestore.collection('animales').doc(animalId).set(animalData);
    } catch (e) {
      throw Exception('Error al crear animal: $e');
    }
  }

  // Crear servicio en 'servicios'
  Future<void> createService(String serviceId, Map<String, dynamic> serviceData) async {
    try {
      serviceData['creadoEn'] = FieldValue.serverTimestamp();
      serviceData['actualizadoEn'] = FieldValue.serverTimestamp();
      
      await _firestore.collection('servicios').doc(serviceId).set(serviceData);
    } catch (e) {
      throw Exception('Error al crear servicio: $e');
    }
  }

  // Crear cita en 'citas'
  Future<void> createAppointment(String appointmentId, Map<String, dynamic> appointmentData) async {
    try {
      appointmentData['creadoEn'] = FieldValue.serverTimestamp();
      appointmentData['actualizadoEn'] = FieldValue.serverTimestamp();
      
      await _firestore.collection('citas').doc(appointmentId).set(appointmentData);
    } catch (e) {
      throw Exception('Error al crear cita: $e');
    }
  }

  // Obtener citas de un ganadero
  Future<List<Map<String, dynamic>>> getFarmerAppointments(String ganaderoId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('citas')
          .where('ganaderoId', isEqualTo: ganaderoId)
          .orderBy('fecha', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Error al obtener citas: $e');
    }
  }

  // Obtener animales de un ganadero
  Future<List<Map<String, dynamic>>> getFarmerAnimals(String ganaderoId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('animales')
          .where('ganaderoId', isEqualTo: ganaderoId)
          .get();
      
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Error al obtener animales: $e');
    }
  }
}
