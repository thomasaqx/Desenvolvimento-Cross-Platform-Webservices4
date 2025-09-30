
class Recipe {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;
  final int prepTimeMinutes;

  Recipe({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.prepTimeMinutes,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['titulo'],
      description: json['descricao'],
      imageUrl: json['imagem'],
      prepTimeMinutes: json['tempo_preparo_minutos'],
    );
  }

  Map<String, dynamic> toJson() => {
        'titulo': title,
        'descricao': description,
        'imagem': imageUrl,
        'tempo_preparo_minutos': prepTimeMinutes,
      };
}