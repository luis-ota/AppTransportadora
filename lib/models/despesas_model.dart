class DespesasDados {
  final String despesaId;
  final String despesa;
  final String descricao;
  final String valor;
  final String tipo;
  final String data;

  DespesasDados(this.despesa, this.descricao, this.valor, this.tipo, this.data,
      {required this.despesaId});
}

class AbastecimentoDados {
  final String abastecimentoId;
  final String quantidadeAbastecida;
  final String tipo;
  final String data;
  final String imageLink;
  final String volumeBomba;

  AbastecimentoDados(this.quantidadeAbastecida, this.tipo, this.data,
      this.imageLink, this.volumeBomba,
      {required this.abastecimentoId});
}
