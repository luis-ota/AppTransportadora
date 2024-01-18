import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class firebaseService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> Acessar(
      {required String usuario, required String senha}) async {
    try{
      usuario = "$usuario@gmail.com";
      await _firebaseAuth.signInWithEmailAndPassword(email: usuario, password: senha);
      return null;
    }on FirebaseAuthException catch(e){
        return e.message;
    }
  }

  Future<void> Sair() async{
    return await _firebaseAuth.signOut();
  }
}
