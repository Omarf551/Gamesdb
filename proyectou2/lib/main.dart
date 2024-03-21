import 'package:flutter/material.dart';
import 'package:proyectou2/Addgames.dart';
import 'package:proyectou2/GameDetailsPage.dart';
import 'package:proyectou2/MyHomePage.dart';
import 'package:proyectou2/LoginPage.dart';
import 'package:proyectou2/CommentPage.dart';
import 'package:proyectou2/models/game.dart';
import 'package:proyectou2/MyAccount.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gamesdb",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)
      ),
      routes: {
        "/": (context) => HomePage(title: 'sa',),
        '/login': (context) => LoginPage(),
        '/add' :(context) => AddGamePage(title: 's',),
        '/comments': (context) => CommentsPage(id_game: ModalRoute.of(context)!.settings.arguments as int),
        '/game_details': (context) => GameDetailsPage(game: ModalRoute.of(context)!.settings.arguments as Game),
        '/user-profile': (context) => UserProfilePage(),
      },
    );
  }
}
