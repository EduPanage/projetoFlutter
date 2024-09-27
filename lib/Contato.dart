class Contato {
  String nome;  // variaveis de contato
  String telefone; 
  String email; 

  // valores informados de contato para criação
  Contato({required this.nome, required this.telefone, required this.email});

  // transformando o contato para um formato que possa ser salvo
  Map<String, String> paraMapa() {
    return {
      'nome': nome,
      'telefone': telefone,
      'email': email,
    };
  }

  factory Contato.deMapa(Map<String, String> mapa) {
    return Contato(
      nome: mapa['nome']!,
      telefone: mapa['telefone']!,
      email: mapa['email']!,
    );
  }
}
