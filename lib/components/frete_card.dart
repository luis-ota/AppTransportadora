import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FreteCard extends StatefulWidget {
  final String destino = 'luis';
  final String origem = 'luis';
  final double compra = 10;
  final double venda = 20;
  final String placa = '';
  final String data = DateFormat('dd/MM/yyyy').format(DateTime.now());

  FreteCard(
      {super.key,
      required destino,
      required origem,
      required placa,
      compra = 0,
      venda = 0,
      data = ''});

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
                                'Destino: ${widget.destino}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text('Origem: ${widget.origem}')
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              'Compra: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(widget.compra)}'),
                          Text(
                              'Venda: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(widget.venda)}'),
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
                        Text(': ${widget.placa}')
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.green,
                        ),
                        Text(
                            ': ${(NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format((widget.venda - widget.compra) * .12))}')
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
                          ': ${widget.data}',
                        )
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          child: const Text('Editar'),
                          onPressed: () {/* ... */},
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
