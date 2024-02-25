import 'package:apprubinho/models/custos_model.dart';
import 'package:apprubinho/screens/form_despesa_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DespesasCard extends StatefulWidget {
  final DespesasDados card;
  final String? uid;

  const DespesasCard({super.key, required this.card, this.uid});

  @override
  State<StatefulWidget> createState() {
    return _DespesasCardState();
  }
}

class _DespesasCardState extends State<DespesasCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ImageIcon(
              AssetImage("lib/assets/img/despesas_icon.png"),
              size: 35,
            ),
            Text(widget.card.data.substring(0, 5))
          ],
        ),
        title: Text(widget.card.despesa),
        subtitle: Text("${limitarString(widget.card.descricao)}\n"
            "valor: ${formatToReal(widget.card.valor)}"),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FormDespesaPage(
                  card: widget.card,
                      action: 'editar',
                      uid: (widget.uid != null) ? widget.uid : null,
                    )));
          },
        ),
        isThreeLine: true,
      ),
    );
  }

  String formatToReal(
    String valor,
  ) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
        .format(double.parse(valor));
  }

  String limitarString(String texto) {
    return texto.length <= 23 ? texto : "${texto.substring(0, 26)}...";
  }
}
