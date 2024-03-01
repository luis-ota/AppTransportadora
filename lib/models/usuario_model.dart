class UsuariosDados {
  late final String uid;
  final String nome;
  late final String? userCredential;
  final String usuario;
  final bool estaAtivo;

  UsuariosDados(
      {required this.userCredential,
      required this.usuario,
      required this.estaAtivo,
      required this.nome,
      required this.uid});
}
