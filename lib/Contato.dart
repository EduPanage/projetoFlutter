class Contato {
  int? id; // Adicionando o campo id para identificar cada contato
  String nome;  // Variáveis de contato
  String telefone; 
  String email; 

  // Construtor para criar um novo contato com os valores informados
  Contato({this.id, required this.nome, required this.telefone, required this.email});

  // Transformando o contato para um formato que possa ser salvo no banco
  Map<String, dynamic> paraMapa() {
    return {
      'id': id, // Incluindo o id no mapa
      'nome': nome,
      'telefone': telefone,
      'email': email,
    };
  }

  // Factory para criar um contato a partir de um mapa
  factory Contato.deMapa(Map<String, dynamic> mapa) {
    return Contato(
      id: mapa['id'], // Extraindo o id do mapa
      nome: mapa['nome']!,
      telefone: mapa['telefone']!,
      email: mapa['email']!,
    );
  }
}
