import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FreteCard extends StatefulWidget {
  const FreteCard({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FreteCardState();
  }
}

class _FreteCardState extends State<FreteCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          children: <Widget>[
            const ListTile(
              leading: ImageIcon(AssetImage("lib/assets/img/caminhao.png"),size: 50,),
              title: Text('Destino: '),
              subtitle: Text('Origem: '),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.now()),
                ),
                const SizedBox(width: 130,),
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
      ),
    );
  }
}
