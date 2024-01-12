import 'package:app_caminhao/components/frete_tabbar.dart';
import 'package:app_caminhao/funcoes/addCard.dart';
import 'package:app_caminhao/screens/despesas_page.dart';
import 'package:flutter/material.dart';
import 'package:app_caminhao/funcoes/addCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
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
                onPressed: () {},
              ),
            ],
          ),
          body: <Widget>[
            const FreteTabbar(),
            const DespesasPage(),
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
                  size: 30,
                ),
                icon: ImageIcon(
                  AssetImage("lib/assets/img/caminhao.png"),
                  size: 25,
                ),
                label: 'Fretes',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.handyman_outlined,
                ),
                icon: Icon(Icons.handyman),
                label: 'Despesas',
              )
              // TODO:
              // NavigationDestination(comissao)
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: addCard,
            child: const Center(child: Icon(Icons.add)),
          )),
    );
  }
}
