class FreteCardDados {
  final String feteId;
  final String origem;
  final String compra;
  final String destino;
  final String venda;
  final String data;
  final String placaCaminhao;

  FreteCardDados(
      this.origem,
      this.compra,
      this.destino,
      this.venda,
      this.data,
      this.placaCaminhao,
      {required this.feteId});
}
