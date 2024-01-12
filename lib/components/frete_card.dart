import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FreteCard extends StatefulWidget {
  String destino = 'luis';
  String origem = 'luis';
  double compra = 10;
  double venda = 20;
  String data = DateFormat('dd/MM/yyyy').format(DateTime.now());

  FreteCard(
      {super.key,
      required this.destino,
      required this.origem,
      this.compra = 0,
      this.venda = 0,
      this.data = ''});

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
          Column(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                      ),
                      Text(
                        widget.data,
                      )
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
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Editar'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Concluir'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
