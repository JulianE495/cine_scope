import 'package:cine_scope/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/add_movie.dart';
import 'screens/list_movies.dart';

class HomePage extends StatefulWidget {
  final String nombreUsuario;
  final String correoElectronico;
  final String fotoPerfil;

  const HomePage({
    required this.nombreUsuario,
    required this.correoElectronico,
    required this.fotoPerfil,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _navigateToAddMovie() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMovieScreen()),
    );
  }

  void _navigateToListMovie() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieListScreen(
          collectionPath: 'movies',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CineScope"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.nombreUsuario),
              accountEmail: Text(widget.correoElectronico),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(widget.fotoPerfil),
              ),
            ),
            ListTile(
              title: Text('Añadir Película'),
              onTap: () {
                _navigateToAddMovie();
              },
            ),
            ListTile(
              title: Text('Lista de Películas'),
              onTap: () {
                _navigateToListMovie();
              },
            ),
            ListTile(
              title: Text('Cerrar Sesión'),
              onTap: () {
                _signOut(); // Add your logout function here
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido, ${widget.nombreUsuario}!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _navigateToAddMovie,
              icon: Icon(Icons.add),
              label: Text('Añadir película'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _navigateToListMovie,
              icon: Icon(Icons.list),
              label: Text('Ver lista de películas'),
            ),
          ],
        ),
      ),
    );
  }

  void _signOut() async {
    // Implement your logout logic here
    // For example, sign out the user and navigate to the login screen
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
