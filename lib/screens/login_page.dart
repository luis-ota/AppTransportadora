import 'package:apprubinho/services/firebase_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _dbFrete = FirebaseService();

  final FirebaseService _auth = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Image.asset(
                              'lib/assets/img/caminhao.png',
                              scale: 3,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Transportadora Rubinho',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Insira seu usuáiro';
                                }
                                return null;
                              },
                              controller: _usuarioController,
                              decoration: const InputDecoration(
                                  labelText: 'Usuário',
                                  border: OutlineInputBorder()),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              onFieldSubmitted: (_) => acessar(),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Senha inválida';
                                }
                                return null;
                              },
                              controller: _senhaController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  labelText: 'Senha',
                                  border: OutlineInputBorder()),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(double.maxFinite,
                                    40), // set width and height
                              ),
                              onPressed: acessar,
                              child: const Text('Acessar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )))),
    );
  }

  acessar() async {
    String usuario = _usuarioController.text;
    String senha = _senhaController.text;

    if (_formKey.currentState!.validate()) {
      await _dbFrete.lerDadosFretes();
      _auth.acessar(usuario: usuario, senha: senha).then((value) {});

    } else {
      print('inválido');
    }
  }
}
