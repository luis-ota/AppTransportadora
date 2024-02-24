import 'package:apprubinho/components/fretes/frete_tabbar.dart';
import 'package:apprubinho/providers/custos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/custos/custos_tabbar.dart';
import '../providers/frete_card_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  bool _carregando = true;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    carregandoFretes();
    carregandoCustos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Transportadora Rubinho'),
            backgroundColor: const Color(0xFF43A0E4),
            actions: [
              IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/home/perfil")),
            ],
          ),
          body: _carregando
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : <Widget>[
                  const FreteTabbar(
                    admin: false,
                  ),
                  const DespesasTabbar(),
                ][currentPageIndex],
          bottomNavigationBar: NavigationBar(
            height: 70,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            indicatorColor: const Color(0xFF43A0E4),
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: ImageIcon(
                  AssetImage("lib/assets/img/caminhao.png"),
                  size: 35,
                ),
                icon: ImageIcon(
                  AssetImage("lib/assets/img/caminhao.png"),
                  size: 30,
                ),
                label: 'Fretes',
              ),
              NavigationDestination(
                selectedIcon: ImageIcon(
                  AssetImage("lib/assets/img/despesas_icon.png"),
                  size: 33,
                ),
                icon: ImageIcon(
                  AssetImage("lib/assets/img/despesas_icon.png"),
                  size: 30,
                ),
                label: 'Custos',
              )
              // TODO:
              // NavigationDestination(comissao)
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'botao',
            onPressed: () {
              if (currentPageIndex == 0) {
                Navigator.pushNamed(context, "/home/form_frete_page");
              }
              if (currentPageIndex == 1) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Center(
                        child: Text(
                          'Selecione o tipo',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, "/home/form_despesa_page");
                              },
                              child: const Text("Despesa"),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, "/home/form_abastecimento_page");
                              },
                              child: const Text("Abastecimento")),
                        ],
                      ),
                    );
                  },
                );
              }
            },
            child: const Center(child: Icon(Icons.add)),
          )),
    );
  }

  Future<void> carregandoFretes() async {
    await Provider.of<FreteCardAndamentoProvider>(context, listen: false)
        .carregarDadosDoBanco();
    if (mounted) {
      await Provider.of<FreteCardConcluidoProvider>(context, listen: false)
          .carregarDadosDoBanco();
    }
    if (mounted) {
      await Provider.of<FreteCardAndamentoProvider>(context, listen: false)
          .organizar();
    }
    if (mounted) {
      await Provider.of<FreteCardConcluidoProvider>(context, listen: false)
          .organizar();
    }

    setState(() {
      _carregando = false;
    });
  }

  Future<void> carregandoCustos() async {
    if (mounted) {
      await Provider.of<DespesasProvider>(context, listen: false)
          .carregarDadosDoBanco();
    }
    if (mounted) {
      await Provider.of<DespesasProvider>(context, listen: false).organizar();
    }

    if (mounted) {
      await Provider.of<AbastecimentoProvider>(context, listen: false)
          .carregarDadosDoBanco();
    }
    if (mounted) {
      await Provider.of<AbastecimentoProvider>(context, listen: false)
          .organizar();
    }

    setState(() {
      _carregando = false;
    });
  }
}
