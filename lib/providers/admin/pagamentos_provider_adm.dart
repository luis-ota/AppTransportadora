import 'package:apprubinho/models/fretecard_model.dart';
import 'package:apprubinho/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseService _dbFrete = FirebaseService();

class PagamentosProvider with ChangeNotifier {
  final Map<String, FreteCardDados> pagamentosUsuarios = {
    '0': FreteCardDados(
        freteId: '0',
        origem: 'De',
        compra: 'Compra',
        destino: 'Para',
        data: 'Data',
        venda: 'Venda',
        placaCaminhao: '',
        status: '')
  };

  List<FreteCardDados> get all {
    return [...pagamentosUsuarios.values];
  }

  int get count {
    return pagamentosUsuarios.length;
  }

  FreteCardDados byIndex(int i) {
    return pagamentosUsuarios.values.elementAt(i);
  }

  Future<void> put(FreteCardDados freteCard) async {
    if (freteCard.freteId.trim().isNotEmpty &&
        pagamentosUsuarios.containsKey(freteCard.freteId)) {
      pagamentosUsuarios.update(freteCard.freteId, (_) => freteCard);
    } else {
      final id = freteCard.freteId;
      pagamentosUsuarios.putIfAbsent(
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
    notifyListeners();
  }

  Future<void> remover(FreteCardDados freteCard) async {
    pagamentosUsuarios.remove(freteCard.freteId);
    notifyListeners();
  }

  Future<double> carregarDadosDoBanco(String? uid) async {
    pagamentosUsuarios.clear();
    put(FreteCardDados(
        freteId: '0',
        origem: 'De',
        compra: 'Compra',
        destino: 'Para',
        data: 'Data',
        venda: 'Venda',
        placaCaminhao: '',
        status: ''));
    double total = 0;
    final mesAtual = DateTime.now().month.toString().padLeft(2, '0');
    final dados = await _dbFrete.lerDadosBanco('Fretes', uid: uid!);
    if (dados?['Concluido'] != null) {
      dados?['Concluido'].forEach((ano, value) {
        dados['Concluido']['$ano'].forEach((mes, value) {
          dados['Concluido']['$ano']['$mes'].forEach((key, value) {
            if (mes == mesAtual && ano == DateTime.now().year.toString()) {
              put(FreteCardDados(
                  origem: value['origem'],
                  compra: formatToReal(value['compra']),
                  destino: value['destino'],
                  venda: formatToReal(value['venda']),
                  data: value['data'].substring(0, 5),
                  placaCaminhao: value['placaCaminhao'],
                  status: 'Concluido',
                  freteId: key));
              total += ( double.tryParse(value['venda'])! - double.tryParse(value['compra'])!);
            }
          });
        });
      });
    }
    return total;
  }

  Future<void> organizar() async {
    Map<String, FreteCardDados> fretesOrdenados = {};

    List<String> chavesOrdenadas = pagamentosUsuarios.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      fretesOrdenados[chave] = pagamentosUsuarios[chave]!;
    }
    pagamentosUsuarios.clear();
    put(FreteCardDados(
        freteId: '0',
        origem: 'De',
        compra: 'Compra',
        destino: 'Para',
        data: 'Data',
        venda: 'Venda',
        placaCaminhao: '',
        status: ''));
    pagamentosUsuarios.addAll(fretesOrdenados);
    notifyListeners();
  }

  String formatToReal(String valor,) {
    String texto = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
        .format(double.parse(valor));
    if(texto.substring(texto.length - 2)=='00') {
      return texto.substring(0, texto.length - 3);
    }else{return texto;}
  }
}

class PagamentosConcluidosProvider with ChangeNotifier {
  final Map<String, FreteCardDados> pagamentosUsuariosConcluidos = {};

  List<FreteCardDados> get all {
    return [...pagamentosUsuariosConcluidos.values];
  }

  int get count {
    return pagamentosUsuariosConcluidos.length;
  }

  FreteCardDados byIndex(int i) {
    return pagamentosUsuariosConcluidos.values.elementAt(i);
  }

  Future<void> put(FreteCardDados freteCard) async {
    if (freteCard.freteId.trim().isNotEmpty &&
        pagamentosUsuariosConcluidos.containsKey(freteCard.freteId)) {
      pagamentosUsuariosConcluidos.update(freteCard.freteId, (_) => freteCard);
    } else {
      final id = freteCard.freteId;
      pagamentosUsuariosConcluidos.putIfAbsent(
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

    notifyListeners();
  }

  Future<void> carregarDadosDoBanco(String? uid) async {
    pagamentosUsuariosConcluidos.clear();
    put(FreteCardDados(
        freteId: '0',
        origem: 'De',
        compra: 'Compra',
        destino: 'Para',
        data: 'Data',
        venda: 'Venda',
        placaCaminhao: '',
        status: ''));

    organizar();
  }

  Future<void> organizar() async {
    Map<String, FreteCardDados> fretesOrdenados = {};

    List<String> chavesOrdenadas = pagamentosUsuariosConcluidos.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      fretesOrdenados[chave] = pagamentosUsuariosConcluidos[chave]!;
    }
    put(FreteCardDados(
        freteId: '0',
        origem: 'De',
        compra: 'Compra',
        destino: 'Para',
        data: 'Data',
        venda: 'Venda',
        placaCaminhao: '',
        status: ''));
    pagamentosUsuariosConcluidos.clear();
    pagamentosUsuariosConcluidos.addAll(fretesOrdenados);
    notifyListeners();
  }

  Future<void> remover(FreteCardDados freteCard) async {
    pagamentosUsuariosConcluidos.remove(freteCard.freteId);
    notifyListeners();
  }
}
