import 'package:flutter/material.dart';

class CustosTabbarIndexProvider with ChangeNotifier {
  int custosTabbarIndex = 0;

  void mudarIndex(int novoIndex) {
    custosTabbarIndex = novoIndex;
    notifyListeners();

    Future.delayed(const Duration(seconds: 20), () {
      custosTabbarIndex = 0;
      notifyListeners();
    });
  }
}
