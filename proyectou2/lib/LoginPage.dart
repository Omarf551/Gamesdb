import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyectou2/MyHomePage.dart';
import 'package:proyectou2/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInUser(BuildContext context) async {
    final String apiUrl = 'https://f6d0-177-228-72-111.ngrok-free.app/api/login'; // Enlace de ngrok para login

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'ngrok-skip-browser-warning': 'true'}, // Encabezado personalizado
      body: json.encode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['message'] == 'success') {
        final userId = responseData['userId'].toString(); // Obtener el ID del usuario
        final accessToken = responseData['access_token'].toString();

        // Guardar el estado de inicio de sesión usando shared_preferences
        final prefs = await SharedPreferences.getInstance();

        prefs.setBool('isLoggedIn', true);
        prefs.setString('accessToken', accessToken);
        prefs.setString('userId', userId); // Guardar el ID del usuario

        print('Valor de userId guardado en SharedPreferences: $userId'); // Imprimir el ID del usuario

        loadUserInfo(responseData['profile']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(title: 'sa'),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to sign in. Please try again.'),
            actions: [
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
  }

  // Método para cargar la información del usuario desde SharedPreferences
  Future<void> loadUserInfo(Map<String, dynamic> profileData) async {
    final prefs = await SharedPreferences.getInstance();
    final accountName = profileData['name'] ?? '';
    final accountEmail = profileData['email'] ?? '';

    prefs.setString('accountName', accountName);
    prefs.setString('accountEmail', accountEmail);
    // Puedes actualizar otras variables de estado según sea necesario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const SizedBox(height: 50),
                Text(
                  'GamesDB',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20), // Esquinas redondeadas
                          ),
                          prefixIcon: Icon(Icons.email),
                          iconColor: Colors.red,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20), // Esquinas redondeadas
                          ),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () => signInUser(context),
                        child: Text('Sign In'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Color de fondo rojo
                          onPrimary: Colors.white, // Color del texto blanco
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
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
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(
                              title: 'register',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Register now',
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
        ),
      ),
    );
  }
}
