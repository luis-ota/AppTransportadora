import 'package:apprubinho/models/custos_model.dart';
import 'package:apprubinho/screens/form_despesa_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DespeasasCard extends StatefulWidget {
  final DespesasDados card;

  const DespeasasCard({super.key, required this.card});

  @override
  State<StatefulWidget> createState() {
    return _DespeasasCardState();
  }
}

class _DespeasasCardState extends State<DespeasasCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const ImageIcon(
          AssetImage("lib/assets/img/despesas_icon.png"),
          size: 40,
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
