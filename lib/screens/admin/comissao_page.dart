import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_service.dart';

class AtualizarPorcentagemComissaoPage extends StatefulWidget {
  final String? porcentagemAtual;

  const AtualizarPorcentagemComissaoPage(
      {super.key, required this.porcentagemAtual});

  @override
  State<StatefulWidget> createState() {
    return _AtualizarPorcentagemComissaoPageState();
  }
}

class _AtualizarPorcentagemComissaoPageState
    extends State<AtualizarPorcentagemComissaoPage> {
  int currentPageIndex = 0;
  final user = FirebaseAuth.instance.currentUser;
  late bool _carregando = false;
  late bool _editMode = false;
  late bool _editado = false;
  final TextEditingController _novaPorcentagem = TextEditingController();

  final FirebaseService _dbPagamentos = FirebaseService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user?.email == 'rubens@apprubinho.com') {
      return Visibility(
        visible: user?.email == 'rubens@apprubinho.com',
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Atualizar Porcentagem Comissão'),
              backgroundColor: const Color(0xFF43A0E4),
            ),
            body: ListView(children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListTile(
                    leading: _carregando
                        ? const CircularProgressIndicator()
                        : const ImageIcon(
                            AssetImage("lib/assets/img/porcentagem.png"),
                            size: 45,
                          ),
                    title: _editMode
                        ? _buildEditableField(
                            _novaPorcentagem, 'Nova porcentagem')
                        : _buildReadOnlyField(
                            'Porcentagem Atual: ${!_editado ? widget.porcentagemAtual : _novaPorcentagem.text.replaceAll('%', '')}%'),
                    trailing: IconButton(
                      icon: Column(
                        children: [
                          const Icon(Icons.edit),
                          Text(
                            _editMode ? 'Salvar' : 'Editar',
                            style: const TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                      onPressed: () => setState(() {
                        if (_editMode) {
                          _saveChanges();
                          _editMode = false;
                        } else {
                          _editMode = true;
                        }
                      }),
                    ),
                  ),
                ),
              )
            ]),
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
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          title: const Text('Tranportadora Rubinho'),
          backgroundColor: const Color(0xFF43A0E4),
        ),
        body: SizedBox(
          height: double.maxFinite,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Voce nao tem acesso a essa área',
                  style: TextStyle(fontSize: 19),
                ),
                TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, "/home"),
                    child: const Text("Voltar"))
              ],
            ),
          ),
        ),
      ));
    }
  }

  Widget _buildEditableField(
      TextEditingController controller, String hintText) {
    return TextField(
      autofocus: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }

  Widget _buildReadOnlyField(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18),
    );
  }

  Future<void> _saveChanges() async {
    setState(() {
      _carregando = true;
    });
    if (_novaPorcentagem.text.isNotEmpty) {
      await _dbPagamentos.atualizarPorcentagemComissao(
          porcentagemComissao: _novaPorcentagem.text.replaceAll('%', ''));
      setState(() {
        _editado = true;
      });
    }
    setState(() {
      _carregando = true;
    });
  }
}
