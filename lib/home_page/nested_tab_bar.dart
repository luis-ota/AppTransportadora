import 'package:flutter/material.dart';
import '../card_frete/frete_card.dart';

class NestedTabBar extends StatefulWidget {
  const NestedTabBar({Key? key}) : super(key: key);

  @override
  State<NestedTabBar> createState() => NestedTabBarState();
}

class NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  List<Widget> andamentoCards = [];
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

  void addAndamentoCard(Widget card) {
    if (!andamentoCards.contains(card)) {
      setState(() {
        andamentoCards.add(card);
      });
    }
  }

  void addConcluidoCard(Widget card) {
    if (!concluidoCards.contains(card)) {
      setState(() {
        concluidoCards.add(card);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Em andamento'),
            Tab(text: 'Concluído'),
          ],
        ),
        Expanded(
          child: TabBarView(
            key: const PageStorageKey<String>('tabBarViewKey'),
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


