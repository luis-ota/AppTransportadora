import 'package:apprubinho/models/usuario_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../services/firebase_service.dart';

class FormUsuarioPage extends StatefulWidget {
  final UsuariosDados? card;
  final String? action;

  const FormUsuarioPage({super.key, this.card, this.action});

  @override
  State<StatefulWidget> createState() {
    return _FormUsuarioPageState();
  }
}

class _FormUsuarioPageState extends State<FormUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  final FirebaseService _dbUsuarios = FirebaseService();
  final User? userAtual = FirebaseAuth.instance.currentUser;

  bool _carregando = false;

  late TextEditingController _nomeController;
  late TextEditingController _usuarioController;
  late TextEditingController _senhaController;
  late bool? _statusUsuario;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.card?.nome ?? '');
    _usuarioController =
        TextEditingController(text: widget.card?.usuario ?? '');
    _senhaController = TextEditingController(text: '');
    _statusUsuario = widget.card?.estaAtivo ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.action == 'editar') {
      _formData['nome'] = widget.card!.nome;
      _formData['usuario'] = widget.card!.usuario;
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: const Row(children: [
            SizedBox(
              width: 15,
            ),
            Icon(
              Icons.person,
              size: 40,
            )
          ]),
          title: const Text(
            'Informações do Usuario',
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: const Color(0xFF43A0E4),
        ),
        body: _carregando
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Preencha com as informações do usuario',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextFormField(
                                  controller: _nomeController,
                                  maxLength: 20,
                                  decoration: const InputDecoration(
                                    labelText: 'Nome do usuário',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.name,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Insira o Nome do usuário';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) =>
                                      _formData['nome'] = value!,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                TextFormField(
                                  controller: _usuarioController,
                                  maxLength: 15,
                                  decoration: const InputDecoration(
                                    labelText: 'Usuário',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.name,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Insira o usuário de acesso';
                                    }
                                    if (value.length < 4) {
                                      return 'O usuario deve conter mais de 4 letras';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) =>
                                      _formData['usuario'] = value!,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                TextFormField(
                                  controller: _senhaController,
                                  maxLength: 15,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    labelText: 'Senha',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Insira a senha do usuário';
                                    }
                                    if (value.length <= 5) {
                                      return 'A senha deve conter mais de 6 caracters';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) =>
                                      _formData['senha'] = value!,
                                ),
                              ])),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(
                              double.maxFinite, 40), // set width and height
                        ),
                        onPressed: () async {
                          if (widget.action == 'editar') {
                            criarUsuario();
                          } else {
                            await criarUsuario();
                          }
                        },
                        child: Text((widget.action == 'editar')
                            ? 'Salvar'
                            : 'Cadastrar'),
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: widget.action == 'editar',
                            child: Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.redAccent,
                                  minimumSize: const Size(double.maxFinite, 40),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title:
                                                const Text('Excluir despesa'),
                                            content: Text(
                                                'Deseja desativar o acesso do usuario ${widget.card?.nome}?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Não'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  excluirUsuario();
                                                },
                                                child: const Text('Sim'),
                                              )
                                            ],
                                          ));
                                },
                                child: const Text('Excluir'),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: widget.action == 'editar',
                              child: const SizedBox(
                                width: 10,
                              )),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(double.maxFinite,
                                    40), // set width and height
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancelar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  criarUsuario() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _carregando = true;
      });

      if (widget.action != 'editar') {
        UsuariosDados usuariosDados = UsuariosDados(
          nome: _formData['nome']!,
          usuario: _formData['usuario']!,
          estaAtivo: true,
          uid: '',
          userCredential: null,
        );
        await _dbUsuarios.cadastrarUsuario(
            usuario: usuariosDados, senha: _formData['senha']!);
      } else {
        UsuariosDados usuariosDados = UsuariosDados(
          nome: _formData['nome']!,
          usuario: _formData['usuario']!,
          estaAtivo: _statusUsuario!,
          uid: FirebaseAuth.instance.currentUser!.uid,
          userCredential: null,
        );
        try {
          if (widget.action == 'editar') {
            await _dbUsuarios.atualizarUsuario(usuario: usuariosDados, uid: '');
          }
        } catch (err) {
          debugPrint(err.toString());
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      if (kDebugMode) {
        print('inválido');
      }
    }
  }

  excluirUsuario() async {
    setState(() {
      _carregando = true;
    });
  }
}
