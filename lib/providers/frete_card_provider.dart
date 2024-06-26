import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/fretecard_model.dart';
import '../services/firebase_service.dart';

final FirebaseService _dbFrete = FirebaseService();

class FreteCardAndamentoProvider with ChangeNotifier {
  final Map<String, FreteCardDados> andamentoCards = {};
  late String porcentagem;

  List<FreteCardDados> get all {
    return [...andamentoCards.values];
  }

  int get count {
    return andamentoCards.length;
  }

  FreteCardDados byIndex(int i) {
    return andamentoCards.values.elementAt(i);
  }

  Future<void> put(FreteCardDados freteCard) async {
    if (freteCard.freteId.trim().isNotEmpty &&
        andamentoCards.containsKey(freteCard.freteId)) {
      andamentoCards.update(freteCard.freteId, (_) => freteCard);
    } else {
      final id = freteCard.freteId;
      andamentoCards.putIfAbsent(
          id,
          () => FreteCardDados(
              origem: freteCard.origem,
              compra: freteCard.compra,
              destino: freteCard.destino,
              venda: freteCard.venda,
              data: freteCard.data,
              placaCaminhao: freteCard.placaCaminhao,
              status: 'Em andamento',
              freteId: id));
    }
    organizar();
    notifyListeners();
  }

  Future<void> remover(FreteCardDados freteCard) async {
    andamentoCards.remove(freteCard.freteId);
    notifyListeners();
  }

  Future<void> carregarDadosDoBanco() async {
    andamentoCards.clear();
    Map? dadosPor =
        await _dbFrete.lerDadosBanco('PorcentagemPagamentos', uid: '');
    porcentagem = dadosPor?['porcentagem'];
    final dados = await _dbFrete.lerDadosBanco('FretesA',
        uid: FirebaseAuth.instance.currentUser!.uid);
    print(dados);
    if (dados != null) {
      dados.forEach((key, value) {
        put(FreteCardDados(
            origem: value['origem'],
            compra: value['compra'],
            destino: value['destino'],
            venda: value['venda'],
            data: value['data'],
            placaCaminhao: value['placaCaminhao'],
            status: 'Em andamento',
            freteId: key));
      });
    }
  }

  Future<void> organizar() async {
    Map<String, FreteCardDados> fretesOrdenados = {};

    List<String> chavesOrdenadas = andamentoCards.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      fretesOrdenados[chave] = andamentoCards[chave]!;
    }
    andamentoCards.clear();
    andamentoCards.addAll(fretesOrdenados);
    notifyListeners();
  }
}

class FreteCardConcluidoProvider with ChangeNotifier {
  final Map<String, FreteCardDados> concluidoCards = {};
  late String porcentagem;

  List<FreteCardDados> get all {
    return [...concluidoCards.values];
  }

  int get count {
    return concluidoCards.length;
  }

  FreteCardDados byIndex(int i) {
    return concluidoCards.values.elementAt(i);
  }

  Future<void> put(FreteCardDados freteCard) async {
    if (freteCard.freteId.trim().isNotEmpty &&
        concluidoCards.containsKey(freteCard.freteId)) {
      concluidoCards.update(freteCard.freteId, (_) => freteCard);
    } else {
      final id = freteCard.freteId;
      concluidoCards.putIfAbsent(
          id,
          () => FreteCardDados(
              origem: freteCard.origem,
              compra: freteCard.compra,
              destino: freteCard.destino,
              venda: freteCard.venda,
              data: freteCard.data,
              placaCaminhao: freteCard.placaCaminhao,
              status: 'Concluido',
              freteId: id));
    }
    organizar();
    notifyListeners();
  }

  Future<void> carregarDadosDoBanco() async {
    concluidoCards.clear();
    Map? dadosPor =
        await _dbFrete.lerDadosBanco('PorcentagemPagamentos', uid: '');
    porcentagem = dadosPor?['porcentagem'];
    final mesAtual = DateTime.now().month.toString().padLeft(2, '0');
    final anoAtual = DateTime.now().year.toString();
    final dados = await _dbFrete.lerDadosBanco('FretesC',
        uid: FirebaseAuth.instance.currentUser!.uid);
    if (dados != null) {
      dados.forEach((key, value) {
        put(FreteCardDados(
                  origem: value['origem'],
                  compra: value['compra'],
                  destino: value['destino'],
                  venda: value['venda'],
                  data: value['data'],
                  placaCaminhao: value['placaCaminhao'],
                  status: 'Concluido',
                  freteId: key));
      });
    }
    organizar();
  }

  Future<void> organizar() async {
    Map<String, FreteCardDados> fretesOrdenados = {};

    List<String> chavesOrdenadas = concluidoCards.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      fretesOrdenados[chave] = concluidoCards[chave]!;
    }
    concluidoCards.clear();
    concluidoCards.addAll(fretesOrdenados);
    notifyListeners();
  }

  Future<void> remover(FreteCardDados freteCard) async {
    concluidoCards.remove(freteCard.freteId);
    notifyListeners();
  }
}
