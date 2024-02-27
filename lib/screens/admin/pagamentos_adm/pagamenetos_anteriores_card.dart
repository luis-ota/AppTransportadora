import 'package:apprubinho/models/pagamento_model.dart';
import 'package:apprubinho/models/usuario_model.dart';
import 'package:apprubinho/providers/admin/pagamentos_provider_adm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PagamentoCard extends StatefulWidget {
  final UsuariosDados userDados;
  final PagamentoDados pagamento;

  const PagamentoCard(
      {super.key, required this.userDados, required this.pagamento});

  @override
  State<StatefulWidget> createState() {
    return _PagamentoCardState();
  }
}

class _PagamentoCardState extends State<PagamentoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.monetization_on_outlined,
                color: Colors.green,
                size: 35,
              ),
              Text(widget.pagamento.data.substring(0, 5))
            ],
          ),
          title: Text('Valor: ${widget.pagamento.valor}'),
          trailing: IconButton(
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Excluir Pagamento'),
                          content:
                              const Text('Excluir o registro de pagamento?'),
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
                                excluirPagamento();
                              },
                              child: const Text('Sim'),
                            )
                          ],
                        ));
              })),
    );
  }

  void excluirPagamento() {
    Provider.of<PagamentosConcluidosProvider>(context, listen: false)
        .remover(widget.pagamento, widget.userDados.uid);
  }
}
