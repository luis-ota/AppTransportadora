import 'package:app_caminhao/components/frete_card.dart';
import 'package:flutter/material.dart';

class FreteTabbar extends StatefulWidget {
  const FreteTabbar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FreteTabbarState();
  }
}

class _FreteTabbarState extends State<FreteTabbar>
    with TickerProviderStateMixin {
  List<Widget> andamentoCards = [FreteCard()];
  List<Widget> concluidoCards = [];
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
                  return andamentoCards[index];
                },
              ),
              ListView.builder(
                itemCount: concluidoCards.length,
                itemBuilder: (context, index) {
                  return concluidoCards[index];
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
