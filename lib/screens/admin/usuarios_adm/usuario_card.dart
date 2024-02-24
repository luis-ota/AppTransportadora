import 'package:apprubinho/models/usuario_model.dart';
import 'package:apprubinho/providers/admin/fretes_usuarios_provider.dart';
import 'package:apprubinho/screens/admin/fretes_usuarios_adm/fretes_usuarios_page_adm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuarioCard extends StatefulWidget {
  final UsuariosDados card;

  const UsuarioCard({super.key, required this.card});

  @override
  State<StatefulWidget> createState() {
    return _UsuarioCardState();
  }
}

class _UsuarioCardState extends State<UsuarioCard> {
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: _carregando
            ? const CircularProgressIndicator()
            : const Icon(
                Icons.person,
                size: 50,
              ),
        title: Text(widget.card.nome),
        trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              carregarDadosUsuario(widget.card.uid);
              if (mounted) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FretesUsuariosPageAdm(
                          card: widget.card,
                        )));
              }
            }),
      ),
    );
  }

  carregarDadosUsuario(uid) async {
    setState(() {
      _carregando = true;
    });
    await Provider.of<VerUsuarioFreteCardAndamentoProvider>(context,
            listen: false)
        .carregarDadosDoBanco(uid);
    if (mounted) {
      await Provider.of<VerUsuarioFreteCardConcluidoProvider>(context,
              listen: false)
          .carregarDadosDoBanco(uid);
    }
    setState(() {
      _carregando = false;
    });
  }
}
