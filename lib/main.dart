import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences.dart';
import 'ListagemDeContatos.dart';
import 'GerenciadorDeContatos.dart';
import 'Login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GerenciadorDeContatos(), // Cria uma instância do GerenciadorDeContatos
      child: const App(),  // Inicia o aplicativo com o widget App
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Define o tema principal do aplicativo
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent, // Cor de fundo do botão flutuante
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,  // Cor dos botões elevados
            textStyle: TextStyle(fontSize: 18),  // Tamanho do texto nos botões
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),  // Borda padrão para campos de texto
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),  // Borda quando o campo está em foco
          ), 
        ),
      ),
      home: FutureBuilder<String?>(
        future: SharedPreferences.getInstance()
            .then((prefs) => prefs.getString('usuario_nome')),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasData && snapshot.data != null) {
            return ListagemDeContatos();
          }
          
          return LoginPage();
        },
      ),
    );
  }
}