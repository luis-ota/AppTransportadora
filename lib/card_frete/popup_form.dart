// popup.dart

import 'package:flutter/material.dart';
import '../home_page/nested_tab_bar.dart';
import 'frete_card.dart';


Future<void> cardFormPopup(BuildContext context, TextEditingController controller, GlobalKey<NestedTabBarState> nestedTabBarKey) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Destino'),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Digite...'),
        controller: controller,
        onSubmitted: (_) => submit(context, controller, nestedTabBarKey),
      ),
      actions: [
        TextButton(
          onPressed: () => submit(context, controller, nestedTabBarKey),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void submit(BuildContext context, TextEditingController controller, GlobalKey<NestedTabBarState> nestedTabBarKey) {
  Navigator.of(context).pop();
  final nestedTabBarState = nestedTabBarKey.currentState;
  if (nestedTabBarState != null && controller.text != '') {
    nestedTabBarState.addAndamentoCard(FreteCard(texto: controller.text, ));
  }
  controller.clear();
}

