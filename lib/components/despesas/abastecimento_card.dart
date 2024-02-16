import 'package:apprubinho/models/despesas_model.dart';
import 'package:apprubinho/screens/form_abastecimento_page.dart';
import 'package:apprubinho/screens/form_despesa_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AbastecimentoCard extends StatefulWidget {
  final AbastecimentoDados card;

  const AbastecimentoCard({super.key, required this.card});

  @override
  State<StatefulWidget> createState() {
    return _AbastecimentoCardState();
  }
}

class _AbastecimentoCardState extends State<AbastecimentoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.local_gas_station,
          size: 40,
        ),
        title: Text(widget.card.tipo),
        subtitle: Column(
          children: [
            Row(
              children: [
                Text("Abastecido: ${widget.card.quantidadeAbastecida} litros"),
              ],
            ),
            Row(
              children: [Icon(Icons.calendar_month), Text(widget.card.data)],
            )
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FormAbastecimentoPage(
                      card: widget.card,
                      action: 'editar',
                    )));
          },
        ),
        isThreeLine: true,
      ),
    );
  }
}
