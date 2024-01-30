import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class firebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _fretesRef = FirebaseDatabase.instance.ref('Fretes');
  final User? user = FirebaseAuth.instance.currentUser;
  Future<String?> acessar(
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
    required String status,
  }) async {
    try {
      // Use push para adicionar um novo filho ao nó 'Fretes'
      await _fretesRef.child('${user?.uid}/$status/$freteId').set({
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

  Future<void> attDadosFretes({
    required String origem,
    required String freteId,
    required String compra,
    required String destino,
    required String venda,
    required String data,
    required String placaCaminhao,
    required String status,
  }) async {
    return await _fretesRef.child('${user?.uid}/$status/$freteId').update({
      'origem': origem,
      'compra': compra,
      'destino': destino,
      'venda': venda,
      'data': data,
      'placaCaminhao': placaCaminhao,
    });
  }

  Future<String?> excluirFrete({
    required String freteId,
    required String status,
  }) async {
    _fretesRef.child('${user?.uid}/$status/$freteId').remove();
    return null;
  }

  Future<Map?> lerDadosFretes() async {
    DatabaseEvent snapshot = await _fretesRef.child('${user?.uid}').once();
    Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
    return data;
  }
}
