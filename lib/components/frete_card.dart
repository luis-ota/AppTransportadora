import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/fretecard_model.dart';

class FreteCard extends StatefulWidget {

  final FreteCardDados card;

  const FreteCard(
      {super.key,
      required this.card,
      });



  @override
  State<StatefulWidget> createState() {
    return _FreteCardState();
  }
}

class _FreteCardState extends State<FreteCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          const ImageIcon(
                            AssetImage("lib/assets/img/caminhao.png"),
                            size: 50,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.card.destino,
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text('Origem: ${widget.card.origem}')
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              'Compra: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(double.parse(widget.card.compra))}'),
                          Text(
                              'Venda: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(double.parse(widget.card.venda))}'),
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
                            ': ${(NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format((double.parse(widget.card.venda) - double.parse(widget.card.compra)) * .12))}')
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
                              Navigator.pushNamed(context, "/home/form_frete_page", arguments: widget.card)
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('Concluir'),
                          onPressed: () {/* ... */},
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
}
