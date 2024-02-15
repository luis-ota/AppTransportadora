import 'package:apprubinho/screens/form_frete_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/fretecard_model.dart';
import '../../providers/frete_card_provider.dart';
import '../../services/firebase_service.dart';

class FreteCard extends StatefulWidget {
  final FreteCardDados card;
  final String status;
  const FreteCard({super.key, required this.card, required this.status});

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
                                  size: 55,
                                  color: Colors.green,
                                ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.card.destino,
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text('origem: ${widget.card.origem}'),
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
                            ': ${formatToReal(((double.parse(widget.card.venda) - double.parse(widget.card.compra)) * .12).toString())}')
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
      await Provider.of<FreteCardAndamentoProvider>(context, listen: false)
          .remover(widget.card);

      await Provider.of<FreteCardConcluidoProvider>(context, listen: false)
          .put(widget.card);
      await _dbFrete.moverFrete(
          status: 'Em andamento',
          card: widget.card,
          paraOnde: 'Concluido');
    }

    if (widget.card.status == 'Concluido') {
      await Provider.of<FreteCardConcluidoProvider>(context, listen: false)
          .remover(widget.card);

      print("removido do concluido");
      await Provider.of<FreteCardAndamentoProvider>(context, listen: false)
          .put(widget.card);

      await _dbFrete.moverFrete(
          card: widget.card,
          status: 'Concluido',
          paraOnde: 'Em andamento');
    }
  }

  String formatToReal(
    String valor,
  ) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
        .format(double.parse(valor));
  }
}
