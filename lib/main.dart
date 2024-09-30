import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ListagemDeContatos.dart';
import 'GerenciadorDeContatos.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GerenciadorDeContatos(), 
      child: const App(), 
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // define o tema principal
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent, 
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // ajusta a cor dos botões
            textStyle: TextStyle(fontSize: 18), // aumenta o tamanho do texto nos botões
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(), // coloca uma borda ao redor dos campos de texto
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2), // ajusta a borda quando o campo está em foco
          ),
        ),
      ),
      home: ListagemDeContatos(), 
    );
  }
}
