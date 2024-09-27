import 'package:flutter/material.dart';
import 'Contato.dart'; 

class GerenciadorDeContatos with ChangeNotifier {

  List<Contato> _contatos = []; // lista de contatos armazenada na memória

  List<Contato> get contatos => _contatos;

  void adicionarContato(Contato contato) { // adiciona um novo contato

    _contatos.add(contato); 
    notifyListeners(); 
  }

  void atualizarContato(int indice, Contato contatoAtualizado) { // atualiza um contato existente

    _contatos[indice] = contatoAtualizado; 
    notifyListeners(); 
  }

  void removerContato(int indice) {  // remove um contato

    _contatos.removeAt(indice); 
    notifyListeners(); 
  }
}
