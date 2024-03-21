import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyectou2/GameDetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:proyectou2/AppBarWidget.dart';
import 'package:proyectou2/DrawerWidget.dart';
import 'package:proyectou2/models/game.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required String title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Game>> futureGames;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    futureGames = fetchGames();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getString('userId') != null;
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  Future<List<Game>> fetchGames() async {
    late List<Game> games;

    try {
      final response = await http.get(
        Uri.parse('https://f6d0-177-228-72-111.ngrok-free.app/api/Game'),
        headers: {'ngrok-skip-browser-warning': 'true'}, // Agregar el encabezado personalizado
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        games = body.map((dynamic item) => Game.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load games');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }

    return games;
  }

  Future<void> toggleLike(Game game) async {
    if (!isLoggedIn) {
      _showLoginRequiredMessage(context);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      userId = userId.toString();
    } else {
      userId = '';
      await prefs.setString('userId', userId);
    }

    print('UserId: $userId');

    try {
      final response = await http.post(
        Uri.parse('https://f6d0-177-228-72-111.ngrok-free.app/api/likes'), // Adaptar el enlace para likes
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'game_id': game.id,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          game.liked = !game.liked;
          game.likes = game.liked ? game.likes + 1 : game.likes - 1;
        });
      } else {
        print('Error al dar like: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al dar like: $e');
    }
  }

  Future<void> _showLoginRequiredMessage(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login required'),
          content: Text(''),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          AppBarWidget(),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.search,
                      color: Colors.red,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.filter_list),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<Game>>(
            future: futureGames,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No games available'));
              } else {
                final filteredGames = snapshot.data!
                    .where((game) =>
                        game.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                    .toList();
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredGames.length,
                  itemBuilder: (context, index) {
                    final game = filteredGames[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameDetailsPage(game: game)),
                        );
                      },
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                game.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Image.network(
                              game.photo,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        toggleLike(game);
                                      },
                                      icon: Icon(
                                        game.liked ? Icons.favorite : Icons.favorite_border,
                                        color: game.liked ? Colors.red : null,
                                      ),
                                    ),
                                    Text('${game.likes}'),
                                    IconButton(
                                      onPressed: () {
                                        if (!isLoggedIn) {
                                          _showLoginRequiredMessage(context);
                                        } else {
                                          // Adaptación del enlace para comentarios
                                          Navigator.pushNamed(
                                            context,
                                            '/comments', // <-- Cambiar esto al enlace adecuado para comentarios
                                            arguments: game.id,
                                          );
                                        }
                                      },
                                      icon: Icon(Icons.comment),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      drawer: DrawerWidget(),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
              child: Icon(Icons.add),
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            )
          : null,
    );
  }
}
