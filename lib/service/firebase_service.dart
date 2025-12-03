import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final String collectionName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseService({required this.collectionName});

  Future<String> create(Map<String, dynamic> dados) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(collectionName)
          .add(dados);

      return docRef.id;
    } catch (erro) {
      throw Exception("erro ao criar o documento: $erro");
    }
  }

  Future<Map<String, dynamic>?> getByEmail(String email) async {
  try {
    final query = await _firestore
        .collection(collectionName)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      return {"id": doc.id, ...doc.data()};
    } else {
      return null;
    }
  } catch (erro) {
    throw Exception("erro ao buscar por email: $erro");
  }
}


  Future<List<Map<String, dynamic>>> readAll() async {
    try {
      final query = await _firestore.collection(collectionName).get();
      return query.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
    } catch (erro) {
      throw Exception("erro ao buscar todos os documentos $erro");
    }
  }

  Future<Map<String, dynamic>?> readById(String id) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(id).get();
      return doc.exists ? doc.data() : null;
    } catch (erro) {
      throw Exception("erro ao buscar por id: $erro");
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();

      if (await readById(id) == null) {
        return true;
      }
      return false;
    } catch (erro) {
      throw ("erro ao deleter $erro");
    }
  }

  Future<void> update(String id, Map<String, dynamic> dados) async {
    try {
      await _firestore.collection(collectionName).doc(id).update(dados);
    } catch (erro) {
      throw Exception("erro ao atualizar dados: $erro");
    }
  }
}
