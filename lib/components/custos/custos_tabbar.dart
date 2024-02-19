import 'package:apprubinho/providers/custos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'abastecimento_card.dart';
import 'despesas_card.dart';

class DespesasTabbar extends StatefulWidget {
  const DespesasTabbar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DespesasTabbarState();
  }
}

class _DespesasTabbarState extends State<DespesasTabbar>
    with TickerProviderStateMixin {
  late DespesasProvider despesasCards = Provider.of(context);
  late AbastecimentoProvider abastecimentoCards = Provider.of(context);
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
            Tab(text: 'Despesas'),
            Tab(text: 'Abastecimentos'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              RefreshIndicator(
                onRefresh: () async =>
                    await Provider.of<DespesasProvider>(context, listen: false)
                        .carregarDadosDoBanco(),
                child: ListView.builder(
                    itemCount: despesasCards.count,
                    itemBuilder: (context, i) =>
                        DespesasCard(card: despesasCards.all.elementAt(i))),
              ),
              RefreshIndicator(
                onRefresh: () async => await Provider.of<AbastecimentoProvider>(
                        context,
                        listen: false)
                    .carregarDadosDoBanco(),
                child: ListView.builder(
                    itemCount: abastecimentoCards.count,
                    itemBuilder: (context, i) => AbastecimentoCard(
                        card: abastecimentoCards.all.elementAt(i))),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
