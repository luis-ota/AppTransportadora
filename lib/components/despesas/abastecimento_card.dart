import 'package:apprubinho/models/custos_model.dart';
import 'package:apprubinho/screens/form_abastecimento_page.dart';
import 'package:flutter/material.dart';

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
        leading: const Icon(
          Icons.local_gas_station,
          size: 40,
        ),
        title: const Text('Abastecimento'),
        subtitle: Column(
          children: [
            Row(
              children: [
                Text("Abastecido: ${widget.card.quantidadeAbastecida} litros"),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.calendar_month),
                Text(widget.card.data)
              ],
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
