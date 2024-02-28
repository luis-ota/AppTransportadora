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
  bool _editouNome = false;

  // bool _editouEmail = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = user!.displayName ?? '';
    _emailController.text = user!.email!.split('@').first;
    _senhaController.text = '';
    _editMode = false;
    _editouNome = false;
    // _editouEmail = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.person),
        title: const Text('Meu perfil'),
        backgroundColor: const Color(0xFF43A0E4),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: user!.photoURL == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 350,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _editMode
                                  ? _buildEditableField(
                                      _nameController, 'Nome do Usuário')
                                  : _buildReadOnlyField(!_editouNome
                                      ? "Nome: ${user!.displayName}"
                                      : "Nome: ${_nameController.text}"),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
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
                ],
              ),
            ],
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
            Visibility(
              visible: user?.email == 'rubens@apprubinho.com',
              child: SizedBox(
                width: 120,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, "/home/admin/homepage_adm");
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.admin_panel_settings),
                      Text('Admitração'),
                    ],
                  ),
                ),
              ),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(
      TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
        ),
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
    if (_nameController.text.isNotEmpty) {
      user!.updateDisplayName(_nameController.text);
    }
    // user!.verifyBeforeUpdateEmail('${_emailController.text}@apprubinho.com');
    if (_senhaController.text.isNotEmpty) {
      try {
        await FirebaseAuth.instance.currentUser!
            .updatePassword(_senhaController.text);
        showSnack(true, '');
      } catch (error) {
        showSnack(false, error.toString());
      }
    }
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _editouNome = true;
      });
    }
    if (_emailController.text.isNotEmpty) {
      setState(() {
        // _editouEmail = true;
      });
    }
  }

  void showSnack(bool status, erro) {
    if (status) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha atualizada com sucesso')));
    } else {
      _senhaController.text = '';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            duration: Duration(seconds: 8),
            content: Text(
                'Erro ao atualizar a senha: a senha deve conter pelo menos 6 caracteres')),
      );
    }
  }
}
