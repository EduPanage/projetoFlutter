import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'Contato.dart'; 
import 'ContatoDAO.dart'; 

class FormularioDeContato extends StatefulWidget {
  final Contato? contato;  // contato a ser editado ou nulo para novo

  FormularioDeContato({this.contato});

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
    if (widget.contato != null) {
      _nomeControlador.text = widget.contato!.nome;
      _telefoneControlador.text = widget.contato!.telefone;
      _emailControlador.text = widget.contato!.email;
    }
  }

  void _salvarContato() async {
    if (_chaveFormulario.currentState!.validate()) {
      // Cria um novo contato com as informações preenchidas
      Contato novoContato = Contato(
        id: widget.contato?.id, // Se for uma edição, mantém o ID
        nome: _nomeControlador.text,
        telefone: _telefoneControlador.text,
        email: _emailControlador.text,
      );

      final contatoDAO = ContatoDAO();
      
      if (widget.contato == null) {
        // Adiciona um novo contato
        await contatoDAO.insertContato(novoContato);
      } else {
        // Atualiza o contato existente
        await contatoDAO.updateContato(novoContato); // Usa o método de atualização
      }

      // Retorna à tela anterior após salvar
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contato == null ? 'Novo Contato' : 'Editar Contato'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _chaveFormulario,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeControlador,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'O nome é obrigatório.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _telefoneControlador,
                decoration: InputDecoration(labelText: 'Telefone'),
                inputFormatters: [formatadorTelefone],
                keyboardType: TextInputType.phone,
                validator: (valor) {
                  if (valor == null || valor.isEmpty || valor.length != 15) {
                    return 'Telefone inválido.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _emailControlador,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (valor) {
                  if (valor == null || valor.isEmpty || !valor.contains('@')) {
                    return 'E-mail inválido.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              ElevatedButton(
                onPressed: _salvarContato,
                child: Text(widget.contato == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
