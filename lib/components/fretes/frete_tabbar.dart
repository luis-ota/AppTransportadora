import 'package:apprubinho/providers/admin/fretes_usuarios_provider.dart';
import 'package:apprubinho/providers/frete_card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'frete_card.dart';

class FreteTabbar extends StatefulWidget {
  final String? uid;
  const FreteTabbar({super.key, this.uid});

  @override
  State<StatefulWidget> createState() {
    return _FreteTabbarState();
  }
}

class _FreteTabbarState extends State<FreteTabbar>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  initState() {
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
                onRefresh: () async => (widget.uid == null)
                    ? await Provider.of<FreteCardAndamentoProvider>(context,
                            listen: false)
                        .carregarDadosDoBanco()
                    : await Provider.of<VerUsuarioFreteCardAndamentoProvider>(
                            context,
                            listen: false)
                        .carregarDadosDoBanco(widget.uid),
                child: ListView.builder(
                    itemCount: (widget.uid == null)
                        ? Provider.of<FreteCardAndamentoProvider>(context).count
                        : Provider.of<VerUsuarioFreteCardAndamentoProvider>(
                                context)
                            .count,
                    itemBuilder: (context, i) => FreteCard(
                          card: (widget.uid == null)
                              ? Provider.of<FreteCardAndamentoProvider>(context)
                                  .all
                                  .elementAt(i)
                              : Provider.of<
                                          VerUsuarioFreteCardAndamentoProvider>(
                                      context)
                                  .all
                                  .elementAt(i),
                          status: 'Em andamento',
                          uid: (widget.uid != null) ? widget.uid : null,
                          porcentagemPagamento: (widget.uid == null)
                              ? Provider.of<FreteCardAndamentoProvider>(context,
                                      listen: false)
                                  .porcentagem
                              : Provider.of<
                                          VerUsuarioFreteCardAndamentoProvider>(
                                      context,
                                      listen: false)
                                  .porcentagem,
                        )),
              ),
              RefreshIndicator(
                onRefresh: () async => (widget.uid == null)
                    ? await Provider.of<FreteCardConcluidoProvider>(context,
                            listen: false)
                        .carregarDadosDoBanco()
                    : await Provider.of<VerUsuarioFreteCardConcluidoProvider>(
                            context,
                            listen: false)
                        .carregarDadosDoBanco(widget.uid),
                child: ListView.builder(
                    itemCount: (widget.uid == null)
                        ? Provider.of<FreteCardConcluidoProvider>(context).count
                        : Provider.of<VerUsuarioFreteCardConcluidoProvider>(
                                context)
                            .count,
                    itemBuilder: (context, i) => FreteCard(
                          card: (widget.uid == null)
                              ? Provider.of<FreteCardConcluidoProvider>(context)
                                  .all
                                  .elementAt(i)
                              : Provider.of<
                                          VerUsuarioFreteCardConcluidoProvider>(
                                      context)
                                  .all
                                  .elementAt(i),
                          status: 'Concluido',
                          uid: (widget.uid != null) ? widget.uid : null,
                          porcentagemPagamento: (widget.uid == null)
                              ? Provider.of<FreteCardConcluidoProvider>(context,
                                      listen: false)
                                  .porcentagem
                              : Provider.of<
                                          VerUsuarioFreteCardConcluidoProvider>(
                                      context,
                                      listen: false)
                                  .porcentagem,
                        )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
