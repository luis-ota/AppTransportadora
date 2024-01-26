import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class firebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final DatabaseReference _fretesRef = FirebaseDatabase.instance.ref('Fretes');
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
    required String status,
  }) async {
    try {
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
    try {
      await _fretesRef.child('${user?.uid}/$status/$freteId').update({
        'origem': origem,
        'compra': compra,
        'destino': destino,
        'venda': venda,
        'data': data,
        'placaCaminhao': placaCaminhao,
      });
    } catch (error) {
      // Trate os erros aqui
      print('Erro ao atualizar dados do frete: $error');
      throw error;
    }
  }


  Future<String?> excluirFrete({
    required String freteId,
    required String status,
  }) async {
    _fretesRef.child('${user?.uid}/$status/$freteId').remove();
  }

  Future<String?> lerDadosFretes() async {
    final snapshot = await _fretesRef.child('${user?.uid}').get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }
  }



}
