import 'dart:async';
import 'package:apprubinho/models/despesas_model.dart';
import 'package:apprubinho/models/fretecard_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  final DatabaseReference _fretesRef = FirebaseDatabase.instance.ref('Fretes');
  final DatabaseReference _despesaRef =
      FirebaseDatabase.instance.ref('Despesas');
  Future<String?> acessar(
      {required String usuario, required String senha}) async {
    try {
      usuario = "$usuario@apprubinho.com";
      await _firebaseAuth.signInWithEmailAndPassword(
          email: usuario, password: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> sair() async {
    return await _firebaseAuth.signOut();
  }

  Future cadastrarFrete({
    required FreteCardDados card,
    required String status,
  }) async {
    try {
      if (status == 'Em andamento') {
        await _fretesRef.child('${user?.uid}/$status/${card.freteId}').set({
          'origem': card.origem,
          'compra': card.compra,
          'destino': card.destino,
          'venda': card.venda,
          'data': card.data,
          'placaCaminhao': card.placaCaminhao,
        });
      } else {
        List<String> partes = card.data.split('/');
        String anoMes = '${partes[2]}/${partes[1]}';
        await _fretesRef
            .child('${user?.uid}/$status/$anoMes/${card.freteId}')
            .set({
          'origem': card.origem,
          'compra': card.compra,
          'destino': card.destino,
          'venda': card.venda,
          'data': card.data,
          'placaCaminhao': card.placaCaminhao,
        });
      }
    } catch (error) {
      // Trate os erros aqui
      print('Erro ao cadastrar frete: $error');
      rethrow;
    }
  }

  Future<void> attDadosFretes(FreteCardDados card, String data) async {
    excluirFrete(card: card, status: card.status, data: data);
    if (card.status == "Em andamento") {
      return await _fretesRef
          .child('${user?.uid}/${card.status}/${card.freteId}')
          .update({
        'origem': card.origem,
        'compra': card.compra,
        'destino': card.destino,
        'venda': card.venda,
        'data': card.data,
        'placaCaminhao': card.placaCaminhao,
      });
    } else {
      List<String> partes = card.data.split('/');
      String anoMes = '${partes[2]}/${partes[1]}';
      return await _fretesRef
          .child('${user?.uid}/${card.status}/$anoMes/${card.freteId}')
          .update({
        'origem': card.origem,
        'compra': card.compra,
        'destino': card.destino,
        'venda': card.venda,
        'data': card.data,
        'placaCaminhao': card.placaCaminhao,
      });
    }
  }

  Future<String?> excluirFrete(
      {required FreteCardDados card,
      required String status,
      required String data}) async {
    List<String> partes = data.split('/');
    String anoMes = '${partes[2]}/${partes[1]}';
    if (status == 'Em andamento') {
      _fretesRef.child('${user?.uid}/${card.status}/${card.freteId}').remove();
    } else {
      _fretesRef
          .child('${user?.uid}/${card.status}/$anoMes/${card.freteId}')
          .remove();
    }
    return null;
  }

  Future<String?> moverFrete({
    required String status,
    required FreteCardDados card,
    required String paraOnde,
  }) async {
    excluirFrete(status: status, card: card, data: card.data);
    cadastrarFrete(card: card, status: paraOnde);
    return null;
  }

  Future<Map?> lerDadosFretes() async {
    DatabaseEvent snapshot = await _fretesRef.child('${user?.uid}').once();
    Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
    return data;
  }

  Future cadastrarDespesa({
     DespesasDados? despesa,
     AbastecimentoDados? abastecimento,
  }) async {
    try {
      List<String> partes = despesa!.data.split('/');
      String anoMes = '${partes[2]}/${partes[1]}';
      if(despesa.tipo=='Despesa'){
        await _despesaRef
            .child(
            '${user?.uid}/Despesas/${despesa.tipo}/$anoMes/${despesa
                .despesaId}')
            .set({
          'despesa': despesa.despesa,
          'valor': despesa.valor,
          'data': despesa.data,
          'descricao': despesa.descricao,
        });
      }else{
        await _despesaRef
            .child(
                '${user?.uid}/Despesas/${abastecimento!.tipo}/$anoMes/${abastecimento.abastecimentoId}')
            .set({
          'despesa': abastecimento.tipo,
          'data': abastecimento.data,
          'nivelBomba': abastecimento.volumeBomba,
          'imageLink': abastecimento.imageLink,
        });
      }
    } catch (error) {
      // Trate os erros aqui
      print('Erro ao cadastrar frete: $error');
      rethrow;
    }
  }

  Future<void> attDadosDespesa(String data, {DespesasDados? despesa, AbastecimentoDados? abastecimento,
  }) async {
    List<String> partes = data.split('/');
    String anoMes = '${partes[2]}/${partes[1]}';
    excluirDespesa(despesa: despesa!, data: data);
    partes = despesa.data.split('/');
    anoMes = '${partes[2]}/${partes[1]}';
    if(despesa.tipo=='Despesa'){

      await _despesaRef
          .child(
          '${user?.uid}/Despesas/${despesa.tipo}/$anoMes/${despesa
              .despesaId}')
          .update({
        'despesa': despesa.despesa,
        'valor': despesa.valor,
        'data': despesa.data,
        'descricao': despesa.descricao,
      });
    }else{
      await _despesaRef
          .child(
              '${user?.uid}/Despesas/${abastecimento!.tipo}/$anoMes/${abastecimento.abastecimentoId}')
          .update({
        'despesa': abastecimento.tipo,
        'data': abastecimento.data,
        'volumeBomba': abastecimento.volumeBomba,
        'imageLink': abastecimento.imageLink,
      });
    }
  }

  Future<String?> excluirDespesa(
      {required DespesasDados despesa, required String data}) async {
    List<String> partes = data.split('/');
    String anoMes = '${partes[2]}/${partes[1]}';
    await _despesaRef
        .child(
            '${user?.uid}/Despesas/$anoMes/${despesa.tipo}/${despesa.despesaId}')
        .remove();
    return null;
  }

  Future<Map?> lerDadosDespesa() async {
    DatabaseEvent snapshot = await _despesaRef.child('${user?.uid}').once();
    Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
    return data;
  }
}
