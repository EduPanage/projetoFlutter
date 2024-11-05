import 'package:flutter/material.dart';
import 'Contato.dart';
import 'ContatoDao.dart';  

class GerenciadorDeContatos with ChangeNotifier {
  List<Contato> _contatos = [];
  final ContatoDAO _contatoDAO = ContatoDAO(); 

  List<Contato> get contatos => _contatos;

  Future<void> adicionarContato(Contato contato) async {
    await _contatoDAO.insertContato(contato);
    await carregarContatos();
    notifyListeners();
  }

  Future<void> atualizarContato(int indice, Contato contatoAtualizado) async {
    await _contatoDAO.updateContato(contatoAtualizado);
    await carregarContatos();
    notifyListeners();
  }

  Future<void> removerContato(int indice) async {
    final contato = _contatos[indice];
    await _contatoDAO.deleteContato(contato.id!);
    await carregarContatos();
    notifyListeners();
  }

  Future<void> carregarContatos() async {
    _contatos = await _contatoDAO.getContatos();
    notifyListeners();
  }
}