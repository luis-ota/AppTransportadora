import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class firebaseService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _freteRef = FirebaseDatabase.instance.ref('Fretes');

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
    required String compra,
    required String destino,
    required String venda,
    required String data,
    required String placaCaminhao,
  }) async {
    await _freteRef.set({
      'origem': origem,
      'compra': compra,
      'destino': destino,
      'venda': venda,
      'data': data,
      'placa caminhao': placaCaminhao,

    });
  }
}

Future<String?> criarAcesso() async {}
