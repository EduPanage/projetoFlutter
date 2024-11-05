import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'secure_dao.dart'; 
import 'usuario.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>(); // Chave para validar o formulário
  final _nomeController = TextEditingController(); 
  final _emailController = TextEditingController(); 
  final _senhaController = TextEditingController(); 
  final _confirmarSenhaController = TextEditingController(); // Controlador para confirmar a senha
  bool _obscureText = true; 
  bool _obscureTextConfirm = true; 

  
  String _hashSenha(String senha) {
    var bytes = utf8.encode(senha); 
    var digest = sha256.convert(bytes); 
    return digest.toString(); // Retorna o hash como string
  }

  // Função para cadastrar um novo usuário
  Future<void> _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      final usuarioDAO = UsuarioSecureDAO(); // Alterado para UsuarioSecureDAO

      final usuarioExistente = await usuarioDAO.getUsuarioByEmail(_emailController.text);
      if (usuarioExistente != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Este email já está cadastrado')),
        );
        return;
      }

      final novoUsuario = Usuario(
        nome: _nomeControlador.text,
        email: _emailController.text,
        senha: _hashSenha(_senhaController.text),
      );

      await usuarioDAO.insertUsuario(novoUsuario);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      Navigator.of(context).pop();
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
