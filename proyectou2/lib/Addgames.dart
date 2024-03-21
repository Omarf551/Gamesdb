import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Game',
      home: AddGamePage(title: 'Add Game'),
    );
  }
}

class AddGamePage extends StatefulWidget {
  final String title;

  AddGamePage({Key? key, required this.title}) : super(key: key);

  @override
  _AddGamePageState createState() => _AddGamePageState();
}

class _AddGamePageState extends State<AddGamePage> {
  final TextEditingController gameNameController = TextEditingController();
  final TextEditingController synopsisController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController photoController = TextEditingController();

  List<String> categories = [];
  Map<String, int> categoryIDs = {};
  String? selectedCategory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final String apiUrl = 'https://f6d0-177-228-72-111.ngrok-free.app/api/Category/';

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {'ngrok-skip-browser-warning': 'true'});

      if (response.statusCode == 200) {
        final categoriesData = json.decode(response.body);
        setState(() {
          categories = List<String>.from(categoriesData.map((category) => category['genre']));
          categoryIDs = {for (var category in categoriesData) category['genre']: category['id']};
          isLoading = false;
        });
      } else {
        throw Exception('Error al obtener las categorías. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener las categorías. Por favor, inténtalo de nuevo.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> addGame(BuildContext context) async {
    final String apiUrl = 'https://f6d0-177-228-72-111.ngrok-free.app/api/Game';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'id_category': (selectedCategory != null ? categoryIDs[selectedCategory]?.toString() : '0'),
        'games': gameNameController.text,
        'photo': photoController.text,
        'synopses': synopsisController.text,
        'review': reviewController.text,
        'likes': '0',
      },
    );

    print('Código de estado: ${response.statusCode}');
    print('Cuerpo de la respuesta: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Game added successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding the game. Please try again'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      'ADD GAME',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: gameNameController,
                            decoration: InputDecoration(
                              labelText: 'Game Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          isLoading
                              ? CircularProgressIndicator()
                              : DropdownButtonFormField<String>(
                                  value: selectedCategory,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCategory = newValue;
                                    });
                                  },
                                  items: categories.map<DropdownMenuItem<String>>((String category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    labelText: 'Category',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 20), // Espacio entre Category y Photo
                          TextFormField(
                            controller: photoController,
                            decoration: InputDecoration(
                              labelText: 'Photo',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: synopsisController,
                            maxLength: 191,
                            decoration: InputDecoration(
                              labelText: 'Synopsis',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: reviewController,
                            maxLines: 5,
                            maxLength: 191,
                            decoration: InputDecoration(
                              labelText: 'Review',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: () => addGame(context),
                            child: Text(
                              'Add Game',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have games?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'View Games',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}