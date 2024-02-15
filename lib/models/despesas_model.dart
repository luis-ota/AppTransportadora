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
  final String abastecimentoiD;
  final String valor;
  final String tipo;
  final String data;
  final String imageLink;
  final String nivelBomba;

  AbastecimentoDados(
      this.valor, this.tipo, this.data, this.imageLink, this.nivelBomba,
      {required this.abastecimentoiD});
}
