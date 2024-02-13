import 'dart:async';
import 'package:apprubinho/models/fretecard_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;


  final DatabaseReference _fretesRef = FirebaseDatabase.instance.ref('Fretes');
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

  Future<void> sair() async {
    return await _firebaseAuth.signOut();
  }

  Future cadastrarFrete({
    required FreteCardDados card,
    required String status,
  }) async {
    try {
      await _fretesRef.child('${user?.uid}/$status/${card.freteId}').set({
        'origem': card.origem,
        'compra': card.compra,
        'destino': card.destino,
        'venda': card.venda,
        'data': card.data,
        'placaCaminhao': card.placaCaminhao,
      });
    } catch (error) {
      // Trate os erros aqui
      print('Erro ao cadastrar frete: $error');
      rethrow;
    }
  }

  Future<void> attDadosFretes(FreteCardDados card) async {
    return await _fretesRef.child('${user?.uid}/${card.status}/${card.freteId}').update({
      'origem': card.origem,
      'compra': card.compra,
      'destino': card.destino,
      'venda': card.venda,
      'data': card.data,
      'placaCaminhao': card.placaCaminhao,
    });
  }

  Future<String?> excluirFrete({
    required String freteId,
    required String status,
  }) async {
    _fretesRef.child('${user?.uid}/$status/$freteId').remove();
    return null;
  }

  Future<String?> moverFrete({
    required String freteId,
    required String status,
    required FreteCardDados card,
    required String paraOnde,

  }) async {
    excluirFrete(freteId: freteId, status: status);
    cadastrarFrete(card: card, status: paraOnde);
    return null;
  }

  Future<Map?> lerDadosFretes() async {
    DatabaseEvent snapshot = await _fretesRef.child('${user?.uid}').once();
    Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
    return data;
  }
}
