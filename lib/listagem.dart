import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gerenciador_de_contatos.dart';
import 'formulario_contato.dart';  // Tela de adicionar ou editar contatos

class Listagem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Agenda'),
      ),
      body: Consumer<GerenciadorDeContatos>(
        builder: (context, gerenciadorDeContatos, child) {
          if (gerenciadorDeContatos.contatos.isEmpty) {
            return Center(child: Text('Nenhum contato cadastrado.'));
          }

          // lista os contatos registrados
          return ListView.builder(
            itemCount: gerenciadorDeContatos.contatos.length,
            itemBuilder: (context, indice) {
              final contato = gerenciadorDeContatos.contatos[indice];
              return ListTile(
                title: Text(contato.nome),
                subtitle: Text('${contato.telefone}\n${contato.email}'),
                isThreeLine: true,
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    gerenciadorDeContatos.removerContato(indice);  //remove o contato 
                  },
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TelaDeFormularioContato(contato: contato, indice: indice),
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TelaDeFormularioContato()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
