import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class firebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final DatabaseReference _freteRef = FirebaseDatabase.instance.ref('Fretes');
  final User? user = FirebaseAuth.instance.currentUser;
  Future<String?> Acessar(
      {required String usuario, required String senha}) async {
    try {
      usuario = "$usuario@apprubinho.com";
      await _firebaseAuth.signInWithEmailAndPassword(
          email: usuario, password: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> Sair() async {
    return await _firebaseAuth.signOut();
  }

  Future cadastrarFrete({
    required String origem,
    required String freteId,
    required String compra,
    required String destino,
    required String venda,
    required String data,
    required String placaCaminhao,
  }) async {
    try {
      // Use push para adicionar um novo filho ao nó 'Fretes'
      await _freteRef.child('${user?.uid}/$freteId').set({
        'origem': origem,
        'compra': compra,
        'destino': destino,
        'venda': venda,
        'data': data,
        'placaCaminhao': placaCaminhao,
      });
    } catch (error) {
      // Trate os erros aqui
      print('Erro ao cadastrar frete: $error');
      throw error;
    }
  }

  Future<void> attDadosFretes() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> editarFrete() async {
    return await _firebaseAuth.signOut();
  }


  Future<String?> criarAcesso() async {}

}

