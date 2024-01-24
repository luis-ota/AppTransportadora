import 'package:flutter/material.dart';
import '../models/despesas_model.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  final Map<String, DespesasDados> userDados = {};

List<DespesasDados> get all {
  return [...userDados.values];
}

int get count {
  return userDados.length;
}
}