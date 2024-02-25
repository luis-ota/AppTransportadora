import 'package:apprubinho/providers/admin/custos_usuarios_provider.dart';
import 'package:apprubinho/providers/custos_provider.dart';
import 'package:apprubinho/providers/custos_tabbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'abastecimento_card.dart';
import 'despesas_card.dart';

class CustosTabbar extends StatefulWidget {
  final String? uid;

  const CustosTabbar({
    super.key,
    this.uid,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustosTabbarState();
  }
}

class _CustosTabbarState extends State<CustosTabbar>
    with TickerProviderStateMixin {
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
    _tabController.index =
        Provider.of<CustosTabbarIndexProvider>(context).custosTabbarIndex;
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
                onRefresh: () async => (widget.uid == null)
                    ? await Provider.of<DespesasProvider>(context,
                            listen: false)
                        .carregarDadosDoBanco()
                    : await Provider.of<VerUsuarioDespesaProvider>(context,
                            listen: false)
                        .carregarDadosDoBanco(widget.uid),
                child: ListView.builder(
                  itemCount: (widget.uid == null)
                      ? Provider.of<DespesasProvider>(context).count
                      : Provider.of<VerUsuarioDespesaProvider>(context).count,
                  itemBuilder: (context, i) => DespesasCard(
                    card: (widget.uid == null)
                        ? Provider.of<DespesasProvider>(context)
                            .all
                            .elementAt(i)
                        : Provider.of<VerUsuarioDespesaProvider>(context)
                            .all
                            .elementAt(i),
                    uid: (widget.uid != null) ? widget.uid : null,
                  ),
                ),
              ),
              RefreshIndicator(
                onRefresh: () async => (widget.uid == null)
                    ? await Provider.of<AbastecimentoProvider>(context,
                            listen: false)
                        .carregarDadosDoBanco()
                    : await Provider.of<VerUsuarioAbastecimentoProvider>(
                            context,
                            listen: false)
                        .carregarDadosDoBanco(widget.uid),
                child: ListView.builder(
                  itemCount: (widget.uid == null)
                      ? Provider.of<AbastecimentoProvider>(context).count
                      : Provider.of<VerUsuarioAbastecimentoProvider>(context)
                          .count,
                  itemBuilder: (context, i) => AbastecimentoCard(
                    card: (widget.uid == null)
                        ? Provider.of<AbastecimentoProvider>(context)
                            .all
                            .elementAt(i)
                        : Provider.of<VerUsuarioAbastecimentoProvider>(context)
                            .all
                            .elementAt(i),
                    uid: (widget.uid != null) ? widget.uid : null,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
