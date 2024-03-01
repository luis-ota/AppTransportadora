import 'package:apprubinho/models/usuario_model.dart';
import 'package:apprubinho/providers/admin/custos_usuarios_provider.dart';
import 'package:apprubinho/providers/admin/fretes_usuarios_provider.dart';
import 'package:apprubinho/screens/admin/custos_adm/custos_usuarios_page_adm.dart';
import 'package:apprubinho/screens/admin/fretes_usuarios_adm/fretes_usuarios_page_adm.dart';
import 'package:apprubinho/screens/admin/pagamentos_adm/pagamentos_page_adm.dart';
import 'package:apprubinho/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuarioCard extends StatefulWidget {
  final UsuariosDados card;
  final String administrar;

  const UsuarioCard({super.key, required this.card, required this.administrar});

  @override
  State<StatefulWidget> createState() {
    return _UsuarioCardState();
  }
}

class _UsuarioCardState extends State<UsuarioCard> {
  bool _carregando = false;
  final FirebaseService _dbPagamentos = FirebaseService();

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
              acessar(widget.administrar);
            }),
      ),
    );
  }

  carregarDadosUsuario(uid, onde) async {
    setState(() {
      _carregando = true;
    });
    if (onde == 'Fretes') {
      await Provider.of<VerUsuarioFreteCardAndamentoProvider>(context,
              listen: false)
          .carregarDadosDoBanco(uid);
      if (mounted) {
        await Provider.of<VerUsuarioFreteCardConcluidoProvider>(context,
                listen: false)
            .carregarDadosDoBanco(uid);
      }
    }
    if (onde == 'Custos') {
      if (mounted) {
        await Provider.of<VerUsuarioDespesaProvider>(context, listen: false)
            .carregarDadosDoBanco(uid);
      }
      if (mounted) {
        await Provider.of<VerUsuarioAbastecimentoProvider>(context,
                listen: false)
            .carregarDadosDoBanco(uid);
      }
    }
    setState(() {
      _carregando = false;
    });
  }

  Future<void> acessar(String administrar) async {
    await carregarDadosUsuario(widget.card.uid, administrar);

    Map? dados =
        await _dbPagamentos.lerDadosBanco('PorcentagemPagamentos', uid: '');

    if (mounted && administrar == 'Fretes') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FretesUsuariosPageAdm(
                card: widget.card,
                porcentagemComissao: dados?['porcentagem'],
              )));
    }
    if (mounted && administrar == 'Custos') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CustosUsuariosPageAdm(
                card: widget.card,
              )));
    }

    if (mounted && administrar == 'Pagamentos') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PagamentosPageAdm(
                userDados: widget.card,
              )));
    }
  }
}
