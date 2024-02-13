import 'package:apprubinho/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<StatefulWidget> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final FirebaseService _auth = FirebaseService();
  final User? user = FirebaseAuth.instance.currentUser;

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
        body: Center(
          // Utilizando o widget Center para centralizar os filhos
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Nome: Luis'),
              Text('id: "${user?.uid}"'),
              const Text('Lucros últimos 15 dias: 10 reais'),
              Visibility(
                  visible: user?.uid == 'WYUO7BaXNCgqpVzqopIM0b6DiEl1',
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, "home/admin/homepage_adm"),
                    child: const Text('Administração'),
                  ))

            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100,
                child: MaterialButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.home), Text('Voltar')],
                    )),
              ),
              const SizedBox(
                width: 50,
              ),
              SizedBox(
                width: 100,
                child: MaterialButton(
                    onPressed: _auth.sair,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.red,
                        ),
                        Text('Sair')
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
