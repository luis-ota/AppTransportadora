import 'package:flutter/material.dart';
import 'frete_card.dart';
import 'nested_tab_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  late final GlobalKey<NestedTabBarState> _nestedTabBarKey;

  @override
  void initState() {
    super.initState();
    _nestedTabBarKey = GlobalKey<NestedTabBarState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tranportadora Rubinho'),
        backgroundColor: Color(0xFF43A0E4),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Adicione aqui a lógica para ação do ícone de perfil
            },
          ),
        ],
      ),
      body: NestedTabBar(key: _nestedTabBarKey),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Use a chave para obter o estado atual de NestedTabBar
          final nestedTabBarState = _nestedTabBarKey.currentState;
          if (nestedTabBarState != null) {
            setState(() {
              // Adicione o FreteCard ao estado atual
              nestedTabBarState.addAndamentoCard(const FreteCard());
            });
          }
        },
      ),
    );
  }
}
