import 'package:flutter/material.dart';

class Listagem extends StatefulWidget {
  const Listagem({super.key});

  @override
  State<Listagem> createState() {
    return _CorpoEstado();
  }
}

class _CorpoEstado extends State<Listagem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: const [
        Text('1'),
        Text('2'),
        Text('7'),
        Text('12'),
        Text('13'),
      ],
    ));
  }
}
