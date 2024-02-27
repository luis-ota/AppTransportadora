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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _editMode = false;
  bool _editSenhaMode = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = user!.displayName ?? '';
    _emailController.text = user!.email!.split('@').first;
    _senhaController.text = '';
    _editMode = false; // Defina o estado inicial de _editMode
  }

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
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: user!.photoURL == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 170,
                        child: Column(
                          children: [
                            _editMode
                                ? _buildEditableField(
                                    _nameController, 'Nome do Usuário')
                                : _buildReadOnlyField(
                                    "Nome: ${user!.displayName}"),
                            const SizedBox(height: 10),
                            _editMode
                                ? _buildEditableField(
                                    _emailController, 'Usuario de Acesso')
                                : _buildReadOnlyField(
                                    "Usuario: ${user!.email!.split('@').first}"),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _editMode = !_editMode;
                            if (!_editMode) {
                              _saveChanges();
                            }
                          });
                        },
                        icon: Column(
                          children: [
                            const Icon(Icons.edit),
                            Text(_editMode ? 'Salvar' : 'Editar'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: _editSenhaMode,
                    child: _buildEditableField(_senhaController, 'Nova Senha'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _editSenhaMode = !_editSenhaMode;
                        if (!_editSenhaMode) {
                          _saveChanges();
                        }
                      });
                    },
                    child: Text(_editSenhaMode ? 'Salvar' : 'Alterar Senha'),
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: user?.email == 'rubens@apprubinho.com',
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, "/home/admin/homepage_adm");
                      },
                      child: const Text('Admitração'),
                    ),
                  )
                ],
              ),
            ),
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
                  ),
                ),
              ),
              const SizedBox(width: 50),
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
      TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }

  Widget _buildReadOnlyField(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20),
    );
  }

  Future<void> _saveChanges() async {
    user!.updateDisplayName(_nameController.text);
    user!.verifyBeforeUpdateEmail(_emailController.text);
    if (_senhaController.text.isNotEmpty) {
      try {
        await FirebaseAuth.instance.currentUser!
            .updatePassword(_senhaController.text);
        showSnack(true, '');
      } catch (error) {
        // Lidar com erros ao atualizar a senha
        showSnack(false, error);
      }
    }

    _nameController.text = user!.displayName ?? '';
    _emailController.text = user!.email!.split('@').first;
    _senhaController.text = '';
  }

  void showSnack(bool status, erro) {
    if (status) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha atualizada com sucesso')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar a senha: $erro')),
      );
    }
  }
}