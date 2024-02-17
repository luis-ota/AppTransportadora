import 'package:flutter/material.dart';

import '../models/custos_model.dart';

class UserProvider with ChangeNotifier {
  final Map<String, DespesasDados> userDados = {};

  List<DespesasDados> get all {
    return [...userDados.values];
  }

  int get count {
    return userDados.length;
  }
}
