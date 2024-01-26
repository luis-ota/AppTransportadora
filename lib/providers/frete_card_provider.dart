import 'package:flutter/material.dart';
import '../models/fretecard_model.dart';
import 'dart:math';

import '../services/firebase_service.dart';

class FreteCardAndamentoProvider with ChangeNotifier {
  final Map<String, FreteCardDados> _andamentoCards = {};
  final firebaseService _dbFrete = firebaseService();

  List<FreteCardDados> get all {
    return [..._andamentoCards.values];
  }

  int get count {
    return _andamentoCards.length;
  }

  FreteCardDados byIndex(int i) {
    return _andamentoCards.values.elementAt(i);
  }

  Future<void> put(FreteCardDados freteCard) async {
    if (freteCard.freteId.trim().isNotEmpty &&
        _andamentoCards.containsKey(freteCard.freteId)) {
      await _dbFrete.attDadosFretes(
        freteId: freteCard.freteId,
        origem: freteCard.origem,
        compra: freteCard.compra,
        destino: freteCard.destino,
        venda: freteCard.venda,
        data: freteCard.data,
        placaCaminhao: freteCard.placaCaminhao,
        status: freteCard.status,
      );

      _andamentoCards.update(freteCard.freteId, (_) => freteCard);
    } else {
      try {
        await _dbFrete.cadastrarFrete(
            freteId: freteCard.freteId,
            origem: freteCard.origem,
            compra: freteCard.compra,
            destino: freteCard.destino,
            venda: freteCard.venda,
            data: freteCard.data,
            placaCaminhao: freteCard.placaCaminhao,
            status: freteCard.status);
      } catch (err) {
        debugPrint(err.toString());
      }
      ;
      final id = freteCard.freteId;
      _andamentoCards.putIfAbsent(
          id,
          () => FreteCardDados(
              freteCard.origem,
              freteCard.compra,
              freteCard.destino,
              freteCard.venda,
              freteCard.data,
              freteCard.placaCaminhao,
              freteCard.status,
              freteId: id));
    }

    notifyListeners();
  }

  Future<void> remover(FreteCardDados freteCard) async {
    if (freteCard != null && freteCard.freteId != null) {
      await _dbFrete.excluirFrete(freteId: freteCard.freteId, status: freteCard.status);
      _andamentoCards.remove(freteCard.freteId);
      notifyListeners();
    }
  }

  void concluir(FreteCardDados freteCard) {
    if (freteCard != null && freteCard.freteId != null) {
      FreteCardConcluidoProvider().put(freteCard);
      _andamentoCards.remove(freteCard.freteId);
      notifyListeners();
    }
  }
}

class FreteCardConcluidoProvider with ChangeNotifier {
  final Map<String, FreteCardDados> _concluidoCards = {};

  List<FreteCardDados> get all {
    return [..._concluidoCards.values];
  }

  int get count {
    return _concluidoCards.length;
  }

  FreteCardDados byIndex(int i) {
    return _concluidoCards.values.elementAt(i);
  }

  void put(FreteCardDados freteCard) {
    if (FreteCardDados == null) {
      return;
    }

    if (freteCard.freteId != null &&
        freteCard.freteId.trim().isNotEmpty &&
        _concluidoCards.containsKey(freteCard.freteId)) {
      _concluidoCards.update(freteCard.freteId, (_) => freteCard);
    } else {
      final id =
          (DateTime.now()).toString().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      _concluidoCards.putIfAbsent(
          id,
          () => FreteCardDados(
              freteCard.origem,
              freteCard.compra,
              freteCard.destino,
              freteCard.venda,
              freteCard.data,
              freteCard.placaCaminhao,
              freteCard.status,
              freteId: id));
    }

    notifyListeners();
  }

  void remover(FreteCardDados freteCard) {
    if (freteCard != null && freteCard.freteId != null) {
      _concluidoCards.remove(freteCard.freteId);
      notifyListeners();
    }
  }
}
