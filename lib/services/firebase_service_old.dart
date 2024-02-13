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

  Future cadastrarFrete(FreteCardDados dados) async {
    try {
      await _fretesRef.child('${user?.uid}/${dados.status}/${dados.freteId}').set({
        'origem': dados.origem,
        'compra': dados.compra,
        'destino': dados.destino,
        'venda': dados.venda,
        'data': dados.data,
        'placaCaminhao': dados.placaCaminhao,
      });
    } catch (error) {
      // Trate os erros aqui
      print('Erro ao cadastrar frete: $error');
      rethrow;
    }
  }

  Future<void> attDadosFretes(FreteCardDados dados) async {
    return await _fretesRef.child('${user?.uid}/${dados.status}/${dados.freteId}').update({
      'origem': dados.origem,
      'compra': dados.compra,
      'destino': dados.destino,
      'venda': dados.venda,
      'data': dados.data,
      'placaCaminhao': dados.placaCaminhao,
    });
  }

  Future<String?> excluirFrete({
    required String freteId,
    required String status,
  }) async {
    _fretesRef.child('${user?.uid}/$status/$freteId').remove();
    return null;
  }

  Future<void> mover(String paraOnde, FreteCardDados card) async {

    excluirFrete(freteId: card.freteId, status: card.status);
    if(paraOnde == 'Em andamento'){

    }

  }

  Future<Map?> lerDadosFretes() async {
    DatabaseEvent snapshot = await _fretesRef.child('${user?.uid}').once();
    Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
    return data;
  }
}
