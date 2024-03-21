import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:proyectou2/models/game.dart';


Future<List<Game>> fetchParts() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/Game/'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body
        .map((dynamic item) => Game.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Fallo al cargar los modelos');
  }
}

class PartList extends StatefulWidget {
  const PartList({super.key, required this.title});

  final String title;

  @override
  State<PartList> createState() => _PartListState();
}

class _PartListState extends State<PartList> {
  late Future<List<Game>> futureParts;
  @override
  void initState() {
    super.initState();
    futureParts = fetchParts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Obtener lista de datos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
      ),
      home: Scaffold(
          body: Center(
        child: FutureBuilder<List<Game>>(
          future: futureParts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!
                    .map((part) => Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 15,
                            ),
                            //Text(part.id.toString()),
                            //Text(part.id_categori.toString()),
                            //Text(part.genre),
                            //Text(part.synopses),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ))
                    .toList(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      )),
    );
  }
}