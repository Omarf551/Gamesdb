class Category {
  final int id;
  final int id_game;
  final String genre;

  Category({
    required this.id,
    required this.id_game,
    required this.genre,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ,
      id_game: json['id_game'],
      genre: json['genre'],
    );
  }
}
