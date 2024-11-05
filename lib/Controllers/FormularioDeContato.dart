import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'Contato.dart';
import 'GerenciadorDeContatos.dart';

class FormularioDeContato extends StatefulWidget {
  final Contato? contato;
  final int? indice;

  FormularioDeContato({this.contato, this.indice});

  @override
  _FormularioDeContatoState createState() => _FormularioDeContatoState();
}

class _FormularioDeContatoState extends State<FormularioDeContato> {
  final _chaveFormulario = GlobalKey<FormState>(); 
  final _nomeControlador = TextEditingController(); 
  final _telefoneControlador = TextEditingController();
  final _emailControlador = TextEditingController(); 

  var formatadorTelefone = MaskTextInputFormatter( 
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
      final gerenciador = Provider.of<GerenciadorDeContatos>(context, listen: false);
      
      Contato novoContato = Contato(
        id: widget.contato?.id,
        nome: _nomeControlador.text,
        telefone: _telefoneControlador.text,
        email: _emailControlador.text,
      );

      if (widget.contato == null) {
        await gerenciador.adicionarContato(novoContato);
      } else {
        await gerenciador.atualizarContato(widget.indice!, novoContato);
      }

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
