import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'GerenciadorDeContatos.dart'; 
import 'Contato.dart'; 

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

  
  var formatadorTelefone = MaskTextInputFormatter( // Formatação do telefone
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    
    if (widget.contato != null) {  // Preenche os campos se estiver editando um contato
      _nomeControlador.text = widget.contato!.nome;
      _telefoneControlador.text = widget.contato!.telefone;
      _emailControlador.text = widget.contato!.email;

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
              // Campo para o nome
              TextFormField(
                controller: _nomeControlador,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'O nome é obrigatório.'; // Validação do nome
                  }
                  return null;
                },
              ),
              
              // Campo para o telefone
              TextFormField(
                controller: _telefoneControlador,
                decoration: InputDecoration(labelText: 'Telefone'),
                inputFormatters: [formatadorTelefone], // Aplica a máscara
                keyboardType: TextInputType.phone,
                validator: (valor) {
                  if (valor == null || valor.isEmpty || valor.length != 15) {
                    return 'Telefone inválido.'; // Validação do telefone
                  }
                  return null;
                },
              ),

              // Campo para o e-mail
              TextFormField(
                controller: _emailControlador,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (valor) {
                  if (valor == null || valor.isEmpty || !valor.contains('@')) {
                    return 'E-mail inválido.'; // Validação do e-mail
                  }
                  return null;
                },
              ),

              // Botão para salvar ou atualizar
              ElevatedButton(
                onPressed: () {
                  if (_chaveFormulario.currentState!.validate()) {
                    Contato novoContato = Contato(
                      nome: _nomeControlador.text,
                      telefone: _telefoneControlador.text,
                      email: _emailControlador.text,
                    );

                    // Adiciona ou atualiza o contato
                    if (widget.indice == null) {
                      Provider.of<GerenciadorDeContatos>(context, listen: false)
                          .adicionarContato(novoContato);
                    } else {
                      Provider.of<GerenciadorDeContatos>(context, listen: false)
                          .atualizarContato(widget.indice!, novoContato);
                    }
                    Navigator.of(context).pop(); // Volta para a tela anterior
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
