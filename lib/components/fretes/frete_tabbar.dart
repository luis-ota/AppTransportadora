import 'package:apprubinho/providers/frete_card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'frete_card.dart';

class FreteTabbar extends StatefulWidget {
  const FreteTabbar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FreteTabbarState();
  }
}

class _FreteTabbarState extends State<FreteTabbar>
    with TickerProviderStateMixin {
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
                onRefresh: () async =>
                    await Provider.of<FreteCardAndamentoProvider>(context,
                            listen: false)
                        .carregarDadosDoBanco(),
                child: ListView.builder(
                    itemCount: andamentoCards.count,
                    itemBuilder: (context, i) => FreteCard(
                          card: andamentoCards.all.elementAt(i),
                          status: 'Em andamento',
                        )),
              ),
              RefreshIndicator(
                onRefresh: () async =>
                    await Provider.of<FreteCardConcluidoProvider>(context,
                            listen: false)
                        .carregarDadosDoBanco(),
                child: ListView.builder(
                    itemCount: concluidoCards.count,
                    itemBuilder: (context, i) => FreteCard(
                          card: concluidoCards.all.elementAt(i),
                          status: 'Concluido',
                        )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
