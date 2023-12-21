import 'package:flutter/material.dart';
import 'nested_tab_bar.dart';
import '../card_frete/popup_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  late final GlobalKey<NestedTabBarState> _nestedTabBarKey;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _nestedTabBarKey = GlobalKey<NestedTabBarState>();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transportadora Rubinho'),
        backgroundColor: const Color(0xFF43A0E4),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Adicione aqui a lógica para ação do ícone de perfil
            },
          ),
        ],
      ),
      body: NestedTabBar(key: _nestedTabBarKey),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await cardFormPopup(context, controller, _nestedTabBarKey);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
