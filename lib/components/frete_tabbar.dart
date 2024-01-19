import 'package:app_caminhao/components/frete_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FreteTabbar extends StatefulWidget {
  const FreteTabbar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FreteTabbarState();
  }
}

class _FreteTabbarState extends State<FreteTabbar>
    with TickerProviderStateMixin {
  Map<String, Widget> andamentoCards = {
    '1': FreteCard(
      destino: 'luis',
      origem: 'lorena',
      compra: 10,
      venda: 30,
      data: '16/01/2024',
      placa: '123bc',
    )
  };
  Map<String, Widget> concluidoCards = {};
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Em andamento'),
            Tab(text: 'Concluído'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ListView.builder(
                itemCount: andamentoCards.length,
                itemBuilder: (context, index) {
                  var keys = andamentoCards.keys.toList();
                  var cardKey = keys[index];
                  return andamentoCards[cardKey]!;
                },
              ),
              ListView.builder(
                itemCount: concluidoCards.length,
                itemBuilder: (context, index) {
                  var keys = concluidoCards.keys.toList();
                  var cardKey = keys[index];
                  return concluidoCards[cardKey]!;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
