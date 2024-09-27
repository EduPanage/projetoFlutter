import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ListagemDeContatos.dart'; 

void main() {
  runApp(const App()); // inicia o aplicativo
}

class App extends StatelessWidget { 
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      home: ListagemDeContatos(), // define a tela inicial
    );
  }
}

