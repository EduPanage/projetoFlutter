import 'package:flutter/material.dart';
import 'Contato.dart';
import 'contato_dao.dart'; // Importando o ContatoDAO para gerenciamento de dados

class GerenciadorDeContatos with ChangeNotifier {
  List<Contato> _contatos = []; // Lista de contatos armazenada na memória
  final ContatoDAO _contatoDAO = ContatoDAO(); // Instância do DAO para interagir com o banco

  List<Contato> get contatos => _contatos; // Getter para acessar a lista de contatos

  // Adiciona um novo contato e salva no banco de dados
  Future<void> adicionarContato(Contato contato) async {
    await _contatoDAO.insertContato(contato); // Insere o contato no banco
    _contatos.add(contato); // Adiciona o contato à lista em memória
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  // Atualiza um contato existente no banco de dados e na lista
  Future<void> atualizarContato(int indice, Contato contatoAtualizado) async {
    final contatoAntigo = _contatos[indice]; // Obtém o contato antigo para referência
    await _contatoDAO.insertContato(contatoAtualizado); // Salva as alterações no banco
    _contatos[indice] = contatoAtualizado; // Atualiza o contato na lista em memória
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  // Remove um contato do banco de dados e da lista
  Future<void> removerContato(int indice) async {
    final contato = _contatos[indice]; // Obtém o contato a ser removido
    await _contatoDAO.deleteContato(contato.id!); // Remove do banco de dados
    _contatos.removeAt(indice); // Remove da lista em memória
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  // Carrega contatos do banco de dados ao iniciar
  Future<void> carregarContatos() async {
    _contatos = await _contatoDAO.getContatos(); // Obtém contatos do banco
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }
}
