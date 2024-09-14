import 'package:flutter/material.dart';

class Cadastro extends StatelessWidget {
  const Cadastro({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
                label: Text("Entre com nome"), border: OutlineInputBorder()),
          ),
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(label: Text("Validade")),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Salvar")),
        ],
      ),
    );
  }
}
