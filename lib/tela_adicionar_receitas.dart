import 'package:flutter/material.dart';
import 'receitas.dart';
import 'api_service.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final ApiService _apiService = ApiService();
  String? _imageUrlPreview;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(() {
      setState(() {
        _imageUrlPreview = _imageUrlController.text;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _prepTimeController.dispose();
    super.dispose();
  }

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final newRecipe = Recipe(
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        prepTimeMinutes: int.parse(_prepTimeController.text),
      );

      try {
        await _apiService.addRecipe(newRecipe);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receita salva com sucesso!')),
        );
        Navigator.of(context).pop(true); 
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar receita: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Nova Receita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'URL da Imagem'),
                  validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 10),
                if (_imageUrlPreview != null && _imageUrlPreview!.isNotEmpty)
                  Image.network(
                    _imageUrlPreview!,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text('URL da imagem inválida ou não foi possível carregar.'),
                  ),
                TextFormField(
                  controller: _prepTimeController,
                  decoration: const InputDecoration(labelText: 'Tempo de Preparo (minutos)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatório';
                    if (int.tryParse(value) == null) return 'Insira um número válido';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _saveRecipe,
                        child: const Text('Salvar'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}