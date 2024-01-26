import 'package:app_caminhao/components/frete_card.dart';
import 'package:app_caminhao/models/fretecard_model.dart';
import 'package:app_caminhao/providers/frete_card_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/firebase_service.dart';

class FreteTabbar extends StatefulWidget {
  FreteTabbar({super.key});
  firebaseService _dbFrete = firebaseService();

  @override
  State<StatefulWidget> createState() {
    return _FreteTabbarState();
  }
}

class _FreteTabbarState extends State<FreteTabbar>
    with TickerProviderStateMixin {
  late FreteCardDados card;
  late FreteCardAndamentoProvider andamentoCards = Provider.of(context);
  late FreteCardConcluidoProvider concluidoCards = Provider.of(context);
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
              RefreshIndicator(
                onRefresh: () async => await widget._dbFrete.lerDadosFretes(),
                child: ListView.builder(
                  itemCount: andamentoCards.count,
                  itemBuilder: (context, i) => FreteCard(card: andamentoCards.all.elementAt(i))
                ),
              ),
              RefreshIndicator(
                onRefresh: () async => await widget._dbFrete.lerDadosFretes(),
                child: ListView.builder(
                    itemCount: concluidoCards.count,
                    itemBuilder: (context, i) => FreteCard(card: concluidoCards.all.elementAt(i))
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
