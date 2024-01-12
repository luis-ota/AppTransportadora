import 'package:flutter/material.dart';

class DespesasPage extends StatefulWidget {
  const DespesasPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DespesasPageState();
  }
}

class _DespesasPageState extends State<DespesasPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_sharp),
              title: Text('Notification 1'),
              subtitle: Text('This is a notification'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_sharp),
              title: Text('Notification 2'),
              subtitle: Text('This is a notification'),
            ),
          ),
        ],
      ),
    );
  }
}
