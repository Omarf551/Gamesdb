class Game {
  final int id;
  final String category;
  final String name;
  final String photo;
  final String synopsis;
  final String review;
  int likes; // Cambiamos a tipo int
  bool liked;


  Game({
    required this.id,
    required this.category,
    required this.name,
    required this.photo,
    required this.synopsis,
    required this.review,
    required this.likes, // Requerimos este valor en el constructor
    this.liked = false,
 
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      category: json['category'],
      name: json['name'],
      photo: json['photo'],
      synopsis: json['synopsis'],
      review: json['review'],
      likes: json['likes'], // Asignamos el valor de likes desde el JSON
      liked: json['liked'] ?? false,
 
    );
  }
}