import 'package:flutter/material.dart';
import 'receitas.dart';
import 'api_service.dart';
import 'tela_adicionar_receitas.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();

    _fetchAndSetRecipes();
  }

  void _fetchAndSetRecipes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recipesFromApi = await _apiService.getRecipes();

      setState(() {
        _recipes = recipesFromApi;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar receitas: $e')));
    }
  }

  void _deleteRecipe(Recipe recipe) async {
    try {
      await _apiService.deleteRecipe(recipe.id!);
      //
      setState(() {
        _recipes.remove(recipe);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receita deletada com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao deletar receita: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Receitas')),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recipes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book, size: 50, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma receita encontrada.\nClique no botão + para adicionar a primeira!',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      recipe.imageUrl,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 40),
                    ),
                    title: Text(
                      recipe.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${recipe.description}\nTempo: ${recipe.prepTimeMinutes} min',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteRecipe(recipe),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );

          if (result == true) {
            _fetchAndSetRecipes();
          }
        },
        backgroundColor: Colors.orange,
        tooltip: 'Adicionar Receita',
        child: const Icon(Icons.add),
      ),
    );
  }
}
