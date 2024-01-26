import 'package:app_caminhao/components/frete_tabbar.dart';
import 'package:app_caminhao/screens/despesas_page.dart';
import 'package:flutter/material.dart';



import '../providers/frete_card_provider.dart';
import '../services/firebase_service.dart';

class HomePage extends StatefulWidget {
   HomePage({super.key});

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
                    onPressed: () =>
                        Navigator.pushNamed(context, "/home/perfil")),
              ],
            ),
            body: <Widget>[
              FreteTabbar(),
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
                  label: 'Despesas',
                )
                // TODO:
                // NavigationDestination(comissao)
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "/home/form_frete_page"),
              child: const Center(child: Icon(Icons.add)),
            )),
      );
  }
}
