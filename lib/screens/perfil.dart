import 'package:app_caminhao/services/firebase_service.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<StatefulWidget> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  firebaseService _auth = firebaseService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: ElevatedButton(
            onPressed: () => _auth.Sair(),
            child: Text('sair'),
          ),
        ),
      ),
    );
  }
}
