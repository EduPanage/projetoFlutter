import 'package:controle_frutas/cadastro.dart';
import 'package:controle_frutas/listagem.dart';
import 'package:flutter/material.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Cadastro()));
            },
            child: const Text("Cadastro")),
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Listagem()));
            },
            child: const Text("Listagem"))
      ]),
    );
  }
}
