import 'dart:async';

import 'package:apprubinho/models/custos_model.dart';
import 'package:apprubinho/models/fretecard_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  final DatabaseReference _fretesRef = FirebaseDatabase.instance.ref('Fretes');
  final DatabaseReference _custosref = FirebaseDatabase.instance.ref('Custos');

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
    if (card.data != data) {
      await excluirFrete(card: card, status: card.status, data: data);
    }
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

  Future<void> cadastrarDespesa({
    required DespesasDados despesa,
  }) async {
    try {
      List<String> partes = despesa.data.split('/');
      String anoMes = '${partes[2]}/${partes[1]}';
      await _custosref
          .child('${user?.uid}/Despesas/$anoMes/${despesa.despesaId}')
          .set({
        'despesa': despesa.despesa,
        'valor': despesa.valor,
        'data': despesa.data,
        'descricao': despesa.descricao,
      });
    } catch (error) {
      // Trate os erros aqui
      print('Erro ao cadastrar despesa: $error');
      rethrow;
    }
  }

  Future<void> attDadosDespesa(
    DespesasDados despesa,
    String data,
  ) async {
    var partes = despesa.data.split('/');
    var anoMes = '${partes[2]}/${partes[1]}';
    if (despesa.data != data) {
      await excluirDespesa(despesa, data);
    }
    await _custosref
        .child('${user?.uid}/Despesas/$anoMes/${despesa.despesaId}')
        .update({
      'despesa': despesa.despesa,
      'valor': despesa.valor,
      'data': despesa.data,
      'descricao': despesa.descricao,
    });
  }

  Future<String?> excluirDespesa(DespesasDados despesa, String data) async {
    List<String> partes = data.split('/');
    String anoMes = '${partes[2]}/${partes[1]}';

    await _custosref
        .child('${user?.uid}/Despesas/$anoMes/${despesa.despesaId}')
        .remove();

    return null;
  }

  Future<Map?> lerDadosDespesas() async {
    DatabaseEvent snapshot = await _custosref.child('${user?.uid}').once();
    Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
    return data;
  }

// Future<void> cadastrarDespesa({
//   required DespesasDados despesa,
//   required AbastecimentoDados abastecimento,
//   String? tipo,
// }) async {
//   try {
//     if (tipo == 'Despesa') {
//       print("cadastrando");
//       List<String> partes = despesa.data.split('/');
//       String anoMes = '${partes[2]}/${partes[1]}';
//       await _despesaRef
//           .child('${user?.uid}/Despesas/Despesa/$anoMes/${despesa.despesaId}')
//           .set({
//         'despesa': despesa.despesa,
//         'valor': despesa.valor,
//         'data': despesa.data,
//         'descricao': despesa.descricao,
//       });
//     } else if (tipo == 'Abastecimento' && abastecimento != null) {
//       print("cadastrando");
//       List<String> partes = abastecimento.data.split('/');
//       String anoMes = '${partes[2]}/${partes[1]}';
//       await _despesaRef
//           .child(
//           '${user?.uid}/Despesas/Abastecimento/$anoMes/${abastecimento.abastecimentoId}')
//           .set({
//         'despesa': 'Abastecimento',
//         'data': abastecimento.data,
//         'quantidadeAbastecida': abastecimento.quantidadeAbastecida,
//         'volumeBomba': abastecimento.volumeBomba,
//         'imageLink': abastecimento.imageLink,
//       });
//     }
//     print("nada aconteceu");
//
//   } catch (error) {
//     // Trate os erros aqui
//     print('Erro ao cadastrar abastecimento ou : $error');
//     rethrow;
//   }
// }
//
// Future<void> attDadosDespesa({
//   String? data,
//   DespesasDados? despesa,
//   AbastecimentoDados? abastecimento,
//   String? tipo,
// }) async {
//   if (tipo == 'Despesa' && despesa != null) {
//     var partes = despesa.data.split('/');
//     var anoMes = '${partes[2]}/${partes[1]}';
//     await excluirDespesa(despesa: despesa, data: data);
//     await _despesaRef
//         .child('${user?.uid}/Despesas/Despesa/$anoMes/${despesa.despesaId}')
//         .update({
//       'despesa': despesa.despesa,
//       'valor': despesa.valor,
//       'data': despesa.data,
//       'descricao': despesa.descricao,
//     });
//   } else if (tipo == 'Abastecimento' && abastecimento != null) {
//     var partes = abastecimento.data.split('/');
//     var anoMes = '${partes[2]}/${partes[1]}';
//     await excluirDespesa(abastecimento: abastecimento, data: data);
//     await _despesaRef
//         .child(
//         '${user?.uid}/Despesas/Abastecimento/$anoMes/${abastecimento.abastecimentoId}')
//         .update({
//       'despesa': 'Abastecimento',
//       'data': abastecimento.data,
//       'quantidadeAbastecida': abastecimento.quantidadeAbastecida,
//       'volumeBomba': abastecimento.volumeBomba,
//       'imageLink': abastecimento.imageLink,
//     });
//   }
// }
//
//
//
// Future<String?> excluirDespesa(
//     {DespesasDados? despesa,
//       AbastecimentoDados? abastecimento,
//       String? tipo,
//       String? data}) async {
//   List<String> partes = data!.split('/');
//   String anoMes = '${partes[2]}/${partes[1]}';
//   if(tipo=="Despesa")
//   {
//     await _despesaRef
//         .child(
//         '${user?.uid}/Despesas/$anoMes/Despesa/${despesa?.despesaId}')
//         .remove();
//   }else{
//     await _despesaRef
//         .child(
//         '${user?.uid}/Despesas/$anoMes/Abastecimento/${abastecimento?.abastecimentoId}')
//         .remove();
//   }
//
//   return null;
// }
//
// Future<Map?> lerDadosDespesa() async {
//   DatabaseEvent snapshot = await _despesaRef.child('${user?.uid}').once();
//   Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
//   return data;
// }
}
