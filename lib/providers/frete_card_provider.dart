import 'package:flutter/material.dart';
import '../models/fretecard_model.dart';
import 'dart:math';



class FreteCardAndamentoProvider with ChangeNotifier {
  final Map<String, FreteCardDados> _andamentoCards = {};

  List<FreteCardDados> get all {
    return [..._andamentoCards.values];
  }

  int get count {
    return _andamentoCards.length;
  }

  FreteCardDados byIndex(int i) {
    return _andamentoCards.values.elementAt(i);
  }

  void put(FreteCardDados freteCard) {

    if (freteCard.feteId.trim().isNotEmpty &&
        _andamentoCards.containsKey(freteCard.feteId)) {
      _andamentoCards.update(freteCard.feteId, (_) => freteCard);
    } else{
      final id = (DateTime.now()).toString().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      _andamentoCards.putIfAbsent(
          id,
              () => FreteCardDados(
              freteCard.origem,
              freteCard.compra,
              freteCard.destino,
              freteCard.venda,
              freteCard.data,
              freteCard.placaCaminhao,
              feteId: id));

    }



    notifyListeners();
  }

  void remover(FreteCardDados freteCard){
    if(freteCard != null && freteCard.feteId != null){
      _andamentoCards.remove(freteCard.feteId);
      notifyListeners();
    }
  }

  void concluir(FreteCardDados freteCard) {
    if(freteCard != null && freteCard.feteId != null){
      FreteCardConcluidoProvider().put(freteCard);
      _andamentoCards.remove(freteCard.feteId);
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

    if (freteCard.feteId != null &&
        freteCard.feteId.trim().isNotEmpty &&
        _concluidoCards.containsKey(freteCard.feteId)) {
      _concluidoCards.update(freteCard.feteId, (_) => freteCard);
    } else{
      final id = (DateTime.now()).toString().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      _concluidoCards.putIfAbsent(
          id,
              () => FreteCardDados(
              freteCard.origem,
              freteCard.compra,
              freteCard.destino,
              freteCard.venda,
              freteCard.data,
              freteCard.placaCaminhao,
              feteId: id));

    }



    notifyListeners();
  }

  void remover(FreteCardDados freteCard){
    if(freteCard != null && freteCard.feteId != null){
      _concluidoCards.remove(freteCard.feteId);
      notifyListeners();
    }
  }

}
