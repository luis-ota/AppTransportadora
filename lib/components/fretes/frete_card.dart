import 'package:apprubinho/providers/admin/fretes_usuarios_provider.dart';
import 'package:apprubinho/screens/form_frete_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/fretecard_model.dart';
import '../../providers/frete_card_provider.dart';
import '../../services/firebase_service.dart';

class FreteCard extends StatefulWidget {
  final FreteCardDados card;
  final String status;
  final String? uid;
  final String porcentagemPagamento;

  const FreteCard(
      {super.key,
      required this.card,
      required this.status,
      this.uid,
      required this.porcentagemPagamento});

  @override
  State<StatefulWidget> createState() {
    return _FreteCardState();
  }
}

class _FreteCardState extends State<FreteCard> {
  final FirebaseService _dbFrete = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          (widget.status == 'Em andamento')
                              ? const ImageIcon(
                                  AssetImage("lib/assets/img/caminhao.png"),
                                  size: 50,
                                )
                              : const Icon(
                            Icons.check_circle_outline_outlined,
                                  size: 50,
                                  color: Colors.green,
                                ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                limitarString(widget.card.destino, 'Destino'),
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                  'origem: ${limitarString(widget.card.origem, 'Origem')}'),
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatToReal(widget.card.venda),
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text('compra: ${formatToReal(widget.card.compra)}'),
                        ],
                      ),
                    ]),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const ImageIcon(
                          AssetImage("lib/assets/img/placa_caminhao.png"),
                          size: 45,
                        ),
                        Text(': ${widget.card.placaCaminhao}')
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.green,
                        ),
                        Text(
                            ': ${formatToReal(((double.parse(widget.card.venda) - double.parse(widget.card.compra)) * (double.parse(widget.porcentagemPagamento) / 100)).toString())}')
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                        ),
                        Text(
                          ': ${widget.card.data}',
                        )
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                            child: const Text('Editar'),
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FormFretePage(
                                      card: widget.card,
                                          action: 'editar',
                                          uid: (widget.uid != null)
                                              ? widget.uid
                                              : null,
                                        )))),
                        const SizedBox(width: 8),
                        TextButton(
                          child: Text(widget.status == 'Concluido'
                              ? 'Restaurar'
                              : 'Concluir'),
                          onPressed: () {
                            mover();
                          },
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> mover() async {
    if (widget.card.status == 'Em andamento') {
      (widget.uid == null)
          ? await Provider.of<FreteCardAndamentoProvider>(context,
                  listen: false)
              .remover(widget.card)
          : await Provider.of<VerUsuarioFreteCardAndamentoProvider>(context,
                  listen: false)
              .remover(widget.card);

      if (mounted) {
        (widget.uid == null)
            ? await Provider.of<FreteCardConcluidoProvider>(context,
                    listen: false)
                .put(widget.card)
            : await Provider.of<VerUsuarioFreteCardConcluidoProvider>(context,
                    listen: false)
                .put(widget.card);
      }
      if (mounted) {
        await _dbFrete.moverFrete(
            status: 'Em andamento',
            card: widget.card,
            paraOnde: 'Concluido',
            uid: (widget.uid == null)
                ? FirebaseAuth.instance.currentUser?.uid
                : widget.uid);
      }
    }

    if (widget.card.status == 'Concluido') {
      if (mounted) {
        (widget.uid == null)
            ? await Provider.of<FreteCardConcluidoProvider>(context,
                    listen: false)
                .remover(widget.card)
            : await Provider.of<VerUsuarioFreteCardConcluidoProvider>(context,
                    listen: false)
                .remover(widget.card);
      }

      if (kDebugMode) {
        print("removido do concluido");
      }
      if (mounted) {
        (widget.uid == null)
            ? await Provider.of<FreteCardAndamentoProvider>(context,
                    listen: false)
                .put(widget.card)
            : await Provider.of<VerUsuarioFreteCardAndamentoProvider>(context,
                    listen: false)
                .put(widget.card);
      }

      await _dbFrete.moverFrete(
          card: widget.card,
          status: 'Concluido',
          paraOnde: 'Em andamento',
          uid: (widget.uid == null)
              ? FirebaseAuth.instance.currentUser?.uid
              : widget.uid);
    }
  }

  String formatToReal(
    String valor,
  ) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
        .format(double.parse(valor));
  }

  String limitarString(String texto, String campo) {
    if (campo == 'Origem') {
      return texto.length <= 10 ? texto : "${texto.substring(0, 10)}...";
    }
    if (campo == 'Destino') {
      return texto.length <= 15 ? texto : "${texto.substring(0, 13)}...";
    }
    return texto;
  }
}
