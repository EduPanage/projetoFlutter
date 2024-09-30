import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'GerenciadorDeContatos.dart'; 
import 'Contato.dart'; 

class FormularioDeContato extends StatefulWidget {

  final Contato? contato;  // contato a ser editado ou nulo para novo
  final int? indice;  // índice do contato na lista

  FormularioDeContato({this.contato, this.indice});

  @override
  _FormularioDeContatoState createState() => _FormularioDeContatoState();
}

class _FormularioDeContatoState extends State<FormularioDeContato> {

  final _chaveFormulario = GlobalKey<FormState>();  // chave global para o formulário
  final _nomeControlador = TextEditingController(); // controla o campo do nome
  final _telefoneControlador = TextEditingController(); // controla o campo do telefone
  final _emailControlador = TextEditingController(); // controla o campo do e-mail

  var formatadorTelefone = MaskTextInputFormatter( // formatação do telefone
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();

    // preenche os campos se estiver editando um contato
    if (widget.contato != null) {
      _nomeControlador.text = widget.contato!.nome;
      _telefoneControlador.text = widget.contato!.telefone;
      _emailControlador.text = widget.contato!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contato == null ? 'Novo Contato' : 'Editar Contato'), // título da página
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _chaveFormulario, // chave usada para validar o formulário
          child: Column(
            children: [
              // campo de texto para o nome
              TextFormField(
                controller: _nomeControlador,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'O nome é obrigatório.';  // validação do campo nome
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // espaçamento entre os campos

              // campo de texto para o telefone
              TextFormField(
                controller: _telefoneControlador,
                decoration: InputDecoration(labelText: 'Telefone'),
                inputFormatters: [formatadorTelefone], // máscara do telefone
                keyboardType: TextInputType.phone,
                validator: (valor) {
                  if (valor == null || valor.isEmpty || valor.length != 15) {
                    return 'Telefone inválido.'; // validação do campo telefone
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // campo de texto para o e-mail
              TextFormField(
                controller: _emailControlador,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (valor) {
                  if (valor == null || valor.isEmpty || !valor.contains('@')) {
                    return 'E-mail inválido.'; // validação do campo e-mail
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // botão para salvar ou atualizar o contato
              ElevatedButton(
                onPressed: () {
                  if (_chaveFormulario.currentState!.validate()) {
                    // cria um novo contato com as informações preenchidas
                    Contato novoContato = Contato(
                      nome: _nomeControlador.text,
                      telefone: _telefoneControlador.text,
                      email: _emailControlador.text,
                    );

                    // adiciona ou atualiza o contato na lista
                    if (widget.indice == null) {
                      Provider.of<GerenciadorDeContatos>(context, listen: false)
                          .adicionarContato(novoContato);
                    } else {
                      Provider.of<GerenciadorDeContatos>(context, listen: false)
                          .atualizarContato(widget.indice!, novoContato);
                    }

                    // retorna à tela anterior após salvar
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.contato == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
