import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FormularioDeContato.dart';
import 'GerenciadorDeContatos.dart';
import 'Contato.dart'; 

class ListagemDeContatos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Agenda'), // Título da tela
      ),
      body: Consumer<GerenciadorDeContatos>(
        builder: (context, gerenciadorDeContatos, child) {
          // Verifica se a lista de contatos está vazia
          if (gerenciadorDeContatos.contatos.isEmpty) {
            return Center(child: Text('Nenhum contato cadastrado.')); // Mensagem para lista vazia
          }

          // Cria uma lista para exibir os contatos
          return ListView.builder(
            itemCount: gerenciadorDeContatos.contatos.length, // Número total de contatos
            itemBuilder: (context, indice) {
              final contato = gerenciadorDeContatos.contatos[indice]; // Obtém o contato na posição atual
              return ListTile(
                title: Text(contato.nome), // Nome do contato
                subtitle: Text('${contato.telefone}\n${contato.email}'), 
                isThreeLine: true, // Permite três linhas na exibição
                trailing: IconButton(
                  icon: Icon(Icons.delete), // botão para deletar o contato
                  onPressed: () {
                    gerenciadorDeContatos.removerContato(indice); // remove o contato da lista
                  },
                ),
                onTap: () {
                  // Navega para a tela de formulário ao tocar no contato
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FormularioDeContato(contato: contato, indice: indice),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega para a tela de formulário para adicionar um novo contato
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FormularioDeContato()),
          );
        },
        child: Icon(Icons.add), // Ícone de adicionar
      ),
    );
  }
}