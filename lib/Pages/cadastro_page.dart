import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'usuario_dao.dart';
import 'usuario.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>(); // Chave para validar o formulário
  final _nomeController = TextEditingController(); // Controlador para o campo de nome
  final _emailController = TextEditingController(); // Controlador para o campo de email
  final _senhaController = TextEditingController(); // Controlador para o campo de senha
  final _confirmarSenhaController = TextEditingController(); // Controlador para confirmar a senha
  bool _obscureText = true; // Controla a visibilidade da senha
  bool _obscureTextConfirm = true; // Controla a visibilidade da confirmação da senha

  // Função para hash da senha usando SHA-256
  String _hashSenha(String senha) {
    var bytes = utf8.encode(senha); // Converte a senha para bytes
    var digest = sha256.convert(bytes); // Cria o hash
    return digest.toString(); // Retorna o hash como string
  }

  // Função para cadastrar um novo usuário
  Future<void> _cadastrar() async {
    if (_formKey.currentState!.validate()) { // Valida o formulário
      final usuarioDAO = UsuarioDAO();

      // Verifica se o email já está cadastrado
      final usuarioExistente = await usuarioDAO.getUsuarioByEmail(_emailController.text);
      if (usuarioExistente != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Este email já está cadastrado')),
        );
        return;
      }

      // Cria um novo usuário
      final novoUsuario = Usuario(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _hashSenha(_senhaController.text),
      );

      await usuarioDAO.insertUsuario(novoUsuario); // Insere o novo usuário no banco

      // Exibe uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      Navigator.of(context).pop(); // Volta para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'), // Título da AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Espaçamento em volta do formulário
        child: Form(
          key: _formKey, // Associa a chave do formulário
          child: ListView(
            children: [
              // Campo para o nome
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Nome é obrigatório'; // Mensagem de erro
                  }
                  return null; // Se válido, retorna null
                },
              ),
              SizedBox(height: 16),
              // Campo para o email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress, // Tipo do teclado
                validator: (valor) {
                  if (valor == null || valor.isEmpty || !valor.contains('@')) {
                    return 'Email inválido'; // Mensagem de erro
                  }
                  return null; // Se válido, retorna null
                },
              ),
              SizedBox(height: 16),
              // Campo para a senha
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton( // Botão para mostrar/ocultar senha
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText; // Alterna a visibilidade
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Senha é obrigatória'; // Mensagem de erro
                  }
                  if (valor.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres'; // Mensagem de erro
                  }
                  return null; // Se válido, retorna null
                },
              ),
              SizedBox(height: 16),
              // Campo para confirmar a senha
              TextFormField(
                controller: _confirmarSenhaController,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton( // Botão para mostrar/ocultar confirmação
                    icon: Icon(
                      _obscureTextConfirm ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureTextConfirm = !_obscureTextConfirm; // Alterna a visibilidade
                      });
                    },
                  ),
                ),
                obscureText: _obscureTextConfirm,
                validator: (valor) {
                  if (valor != _senhaController.text) {
                    return 'As senhas não coincidem'; // Mensagem de erro
                  }
                  return null; // Se válido, retorna null
                },
              ),
              SizedBox(height: 24),
              // Botão para cadastrar
              ElevatedButton(
                onPressed: _cadastrar,
                child: Text('Cadastrar'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Tamanho do botão
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
