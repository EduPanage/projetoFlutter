import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'secure_dao.dart'; 

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Chave para validar o formulário
  final _emailController = TextEditingController(); 
  final _senhaController = TextEditingController(); 
  bool _obscureText = true; 

 
  String _hashSenha(String senha) {
    var bytes = utf8.encode(senha); // Codifica a senha para bytes
    var digest = sha256.convert(bytes); // Cria o hash
    return digest.toString(); // Retorna a representação em string do hash
  }

  // Função para fazer login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final usuarioDAO = UsuarioSecureDAO(); // Alterado para UsuarioSecureDAO
      final usuario = await usuarioDAO.getUsuarioByEmail(_emailController.text);

      if (usuario != null && usuario.senha == _hashSenha(_senhaController.text)) {
        final storage = const FlutterSecureStorage(); // Usando SecureStorage em vez de SharedPreferences
        await storage.write(key: 'usuario_nome', value: usuario.nome);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ListagemDeContatos()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email ou senha inválidos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'), // Título da AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Espaçamento em volta do formulário
        child: Form(
          key: _formKey, // Associa a chave do formulário
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController, 
                decoration: InputDecoration(
                  labelText: 'Email', 
                  prefixIcon: Icon(Icons.email), 
                ),
                keyboardType: TextInputType.emailAddress, // Tipo do teclado
                validator: (valor) { // Validação do campo
                  if (valor == null || valor.isEmpty || !valor.contains('@')) {
                    return 'Email inválido'; // Mensagem de erro
                  }
                  return null; 
                },
              ),
              
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
                obscureText: _obscureText, // Controla a visibilidade da senha
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Senha é obrigatória'; // Mensagem de erro
                  }
                  return null; 
                },
              ),
              // Botão de login
              ElevatedButton(
                onPressed: _login, // Chama a função de login
                child: Text('Entrar'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Tamanho do botão
                ),
              ),
              // Botão para navegar para a página de cadastro
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CadastroPage()),
                  );
                },
                child: Text('Não tem conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
