import 'package:apprubinho/services/firebase_service.dart';
import 'package:flutter/foundation.dart';
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
  late bool _carregando = false;
  late bool _logou = true;
  final FirebaseService _auth = FirebaseService();
  bool _disposed =
      false; // Adiciona esta variável para rastrear se o widget foi descartado

  @override
  void dispose() {
    _disposed = true; // Define _disposed como true quando o widget é descartado
    super.dispose();
  }

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
                            return 'Insira seu usuário';
                          }
                          return null;
                        },
                        controller: _usuarioController,
                        decoration: const InputDecoration(
                            labelText: 'Usuário', border: OutlineInputBorder()),
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
                            labelText: 'Senha', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: !_logou,
                        child: const Text(
                          '* Usuário ou senha incorretos, tente novamente',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(
                              double.maxFinite, 40), // set width and height
                        ),
                        onPressed: acessar,
                        child: _carregando
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const Text('Acessar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> acessar() async {
    if (_disposed)
      return false; // Verifica se o widget foi descartado antes de continuar

    setState(() {
      _carregando = true;
    });
    String usuario = _usuarioController.text;
    String senha = _senhaController.text;

    if (_formKey.currentState!.validate()) {
      bool resultado = await _auth.acessar(usuario: usuario, senha: senha);
      if (!_disposed) {
        // Verifica novamente se o widget foi descartado antes de chamar setState()
        setState(() {
          _logou = resultado;
          _carregando = false;
        });
      }
      return resultado;
    } else {
      if (kDebugMode) {
        print('inválido');
      }
      if (!_disposed) {
        // Verifica novamente se o widget foi descartado antes de chamar setState()
        setState(() {
          _logou = false;
          _carregando = false;
        });
      }
      return false;
    }
  }
}
