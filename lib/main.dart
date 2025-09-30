import 'package:flutter/material.dart';
import 'tela_lista_de_receitas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Receitas',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const RecipeListScreen(),
    );
  }
}
