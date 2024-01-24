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
        appBar: AppBar(
          leading: const Row(children: [
            SizedBox(
              width: 25,
            ),
            Icon(Icons.person),
          ]),
          title: const Text('Meu perfil'),
          backgroundColor: const Color(0xFF43A0E4),
        ),
        body: const Center( // Utilizando o widget Center para centralizar os filhos
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Nome: Luis'),
              Text('Lucros últimos 15 dias: 10 reais')
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100,
                child: FilledButton.tonal(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Column(
                      children: [Icon(Icons.home), Text('Voltar')],
                    )),
              ),
              const SizedBox(width: 50,),
              SizedBox(
                width: 100,
                child: FilledButton.tonal(
                    onPressed: _auth.Sair,
                    child: const Column(
                      children: [Icon(Icons.logout_rounded), Text('Sair')],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
