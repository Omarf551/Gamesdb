import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:proyectou2/MyAccount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyectou2/LoginPage.dart'; // Importa el archivo LoginPage.dart

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String accountName = '';
  String accountEmail = '';
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accountName = prefs.getString('accountName') ?? '';
      accountEmail = prefs.getString('accountEmail') ?? '';
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      isLoggedIn = false;
      accountName = '';
      accountEmail = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              accountName: isLoggedIn
                  ? Text(
                      accountName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
              accountEmail: isLoggedIn
                  ? Text(
                      accountEmail,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      'To access all features',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          InkWell(
            onTap: () {
              
              Navigator.pushNamed(context, '/');
            },
            child: ListTile(
              leading: Icon(
                CupertinoIcons.home,
                color: Colors.red,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (isLoggedIn)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(),
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  "My Account",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (!isLoggedIn)
            InkWell(
              onTap: () {
                // Navigate to LoginPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (isLoggedIn)
            InkWell(
              onTap: () {
                
               
                logout();
              },
              child: ListTile(
                title: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}















/*

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String accountName = '';
  String accountEmail = '';

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accountName = prefs.getString('accountName') ?? '';
      accountEmail = prefs.getString('accountEmail') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              accountName: Text(
                accountName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                accountEmail,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              currentAccountPicture: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  //backgroundImage: AssetImage("assets/user_image.jpg"),
                  radius: 40,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // Navegar a MyHomePage
              Navigator.pushNamed(context, '/');
            },
            child: ListTile(
              leading: Icon(
                CupertinoIcons.home,
                color: Colors.red,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // Acción para My Account
            },
            child: ListTile(
              leading: Icon(
                CupertinoIcons.person,
                color: Colors.red,
              ),
              title: Text(
                "My Account",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // Navegar a LoginPage
              Navigator.pushNamed(context, '/login');
            },
            child: ListTile(
              leading: Icon(
                CupertinoIcons.person,
                color: Colors.red,
              ),
              title: Text(
                "LoginPage",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // Acción para Home (repetido)
            },
            child: ListTile(
              leading: Icon(
                CupertinoIcons.home,
                color: Colors.red,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}







*/