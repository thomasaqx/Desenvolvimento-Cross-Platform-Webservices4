import 'dart:convert';
import 'package:http/http.dart' as http;
import 'receitas.dart';

class ApiService {

  static const String _baseUrl = 'https://generic-items-api-a785ff596d21.herokuapp.com';   
  static const String _rm = '550347'; 

  Future<List<Recipe>> getRecipes() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/receitas/$_rm'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Recipe> recipes =
          body.map((dynamic item) => Recipe.fromJson(item)).toList();
      return recipes;
    } else {
      throw Exception('Falha ao carregar receitas');
    }
  }

  Future<Recipe> addRecipe(Recipe recipe) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/receitas'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(recipe.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao adicionar receita. Status: ${response.statusCode}');
    }
  }

  Future<void> deleteRecipe(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/receitas/$_rm/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao deletar receita. Status: ${response.statusCode}');
    }
  }
}