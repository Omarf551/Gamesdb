class Comment {
  final int id;
  final String comment;
  final String datetime;
  final User? user; // Cambiamos user a ser nullable
  final int? idGame; // Agregamos el campo idGame

  Comment({
    required this.id,
    required this.comment,
    required this.datetime,
    this.user, // Permitimos que user sea nulo
    this.idGame, // Permitimos que idGame sea nulo
  });

  factory Comment.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Comment(id: 0, comment: '', datetime: '');
    }

    return Comment(
      id: json['id'],
      comment: json['comment'],
      datetime: json['datetime'],
      user: json['user'] != null ? User.fromJson(json['user']) : null, // Manejamos valor nulo
      idGame: json['id_game'], // Asignamos el valor de id_game
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return User(id: 0, name: '', email: '');
    }

    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
