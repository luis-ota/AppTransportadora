import 'package:flutter/material.dart';
import '../models/despesas_model.dart';

class DespesasProvider with ChangeNotifier {
  final Map<String, DespesasDados> _despesasCards = {};

  List<DespesasDados> get all {
    return [..._despesasCards.values];
  }

  int get count {
    return _despesasCards.length;
  }
}
