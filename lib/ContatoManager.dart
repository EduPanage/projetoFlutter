import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // transformar o contato em texto e vice-versa

class ContatoManager with ChangeNotifier {

  List<Contato> _contatos = []; 

  List<Contato> get contatos => _contatos;

  // Carrega os contatos do celular
  Future<void> carregarContatos() async {
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    String? dadosDosContatos = preferencias.getString('contatos');
    List<dynamic> decodificado = jsonDecode(dadosDosContatos);
    _contatos = decodificado.map((item) => Contato.deMapa(item)).toList();
    notifyListeners();
    }

  // Adiciona um novo contato
  void adicionarContato(Contato contato) {
    _contatos.add(contato); // Adiciona o contato a lista
    salvarContatos();  // salva os contatos atualizdos no celular
    notifyListeners();
  }

  // atualiza um contato
  void atualizarContato(int indice, Contato contatoAtualizado) {
    _contatos[indice] = contatoAtualizado;  // atualiza o contato na lista
    salvarContatos();  // Salva a lista atualizada
    notifyListeners();
  }

  // Remove um contato
  void removerContato(int indice) {
    _contatos.removeAt(indice);  // Remove o contato da lista
    salvarContatos();  // Salva a lista atualizada
    notifyListeners();
  }

  // Salva os contatos no celular
  Future<void> salvarContatos() async {
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    String dadosDosContatos = jsonEncode(_contatos.map((contato) => contato.paraMapa()).toList());
    preferencias.setString('contatos', dadosDosContatos);  // Salva os contatos como texto
  }
}

