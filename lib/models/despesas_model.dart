class DespesasDados {
  final String despesaId;
  final String titulo;
  final String descricao;
  final String valor;
  final String tipo;

  DespesasDados(this.titulo, this.descricao, this.valor, this.tipo,
      {required this.despesaId});
}
