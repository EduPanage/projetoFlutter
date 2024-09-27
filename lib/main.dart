import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App()); // inicia o aplicativo
}

class App extends StatelessWidget { 
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      home: Principal(), // define a tela inicial
    );
  }
}

