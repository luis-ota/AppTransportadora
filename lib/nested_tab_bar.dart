import 'package:flutter/material.dart';
import 'frete_card.dart';

class NestedTabBar extends StatefulWidget {
  const NestedTabBar({super.key});

  @override
  State<NestedTabBar> createState() => NestedTabBarState();
}

class NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  List<Widget> AndamentoCards = [];
  List<Widget> ConcluidoCards = [];
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

  // Método público para adicionar um card em andamento
  void addAndamentoCard(Widget card) {
    setState(() {
      AndamentoCards.add(card);
    });
  }

  // Método público para adicionar um card concluído
  void addConcluidoCard(Widget card) {
    setState(() {
      ConcluidoCards.add(card);
    });
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
            controller: _tabController,
            children: <Widget>[
              ListView.builder(
                itemCount: AndamentoCards.length,
                itemBuilder: (context, index) {
                  return AndamentoCards[index];
                },
              ),
              ListView.builder(
                itemCount: ConcluidoCards.length,
                itemBuilder: (context, index) {
                  return ConcluidoCards[index];
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
