import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyectou2/models/comment.dart';

class CommentsPage extends StatefulWidget {
  final int id_game;

  const CommentsPage({Key? key, required this.id_game}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late Future<List<Comment>> futureComments;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureComments = fetchComments();
  }

  Future<List<Comment>> fetchComments() async {
    final response =
        await http.get(
          Uri.parse('https://f6d0-177-228-72-111.ngrok-free.app/api/Comment/${widget.id_game}'),
          headers: {'ngrok-skip-browser-warning': 'true'}, // Agrega este encabezado para omitir la advertencia de ngrok
        );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Comment.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> addComment() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      // El usuario no ha iniciado sesión, manejar el caso según sea necesario
      return;
    }

    final intUserId = int.tryParse(userId);

    final response = await http.post(
      Uri.parse('https://f6d0-177-228-72-111.ngrok-free.app/api/Comment'),
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true', // Agrega este encabezado para omitir la advertencia de ngrok
      },
      body: jsonEncode({
        'id_game': widget.id_game,
        'id_user': intUserId,
        'comment': _commentController.text,
      }),
    );

    if (response.statusCode == 201) {
      // Si la solicitud se realizó con éxito (código 201), limpiamos el TextField
      _commentController.clear();

      // Actualizamos la lista de comentarios para mostrar el nuevo comentario
      setState(() {
        futureComments = fetchComments();
      });
    } else {
      print('Error al agregar comentario: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: futureComments,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final comment = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          subtitle: Text(comment.comment),
                          trailing: Text(comment.datetime),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Borde redondeado
                      border: Border.all(color: const Color.fromARGB(255, 236, 0, 0)), // Borde de color gris
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add comment',
                          border: InputBorder.none, // Eliminar el borde predeterminado
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: addComment,
                  icon: Icon(Icons.send, color: Colors.red), // Cambio de color a rojo
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
