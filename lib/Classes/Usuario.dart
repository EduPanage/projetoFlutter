class Usuario {
  int? id; // ID do usuário (opcional)
  String nome; // Nome do usuário
  String email; // Email do usuário
  String senha; // Senha do usuário

  // Construtor que requer nome, email e senha, e opcionalmente o ID
  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  // Converte o objeto Usuario para um mapa
  Map<String, dynamic> paraMapa() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  // Cria um objeto Usuario a partir de um mapa
  factory Usuario.deMapa(Map<String, dynamic> mapa) {
    return Usuario(
      id: mapa['id'],
      nome: mapa['nome'],
      email: mapa['email'],
      senha: mapa['senha'],
    );
  }
}
