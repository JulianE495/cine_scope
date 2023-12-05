import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../movie.dart';
import './details_movie.dart'; // Importa la pantalla de detalles

class MovieListScreen extends StatefulWidget {
  final String? collectionPath;

  MovieListScreen({required this.collectionPath});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Stream<List<Movie>> _moviesStream;

  @override
  void initState() {
    super.initState();
    if (widget.collectionPath != null && widget.collectionPath!.isNotEmpty) {
      _loadMovies();
    } else {
      // Manejar el caso en que collectionPath es nulo o vacío
      print('Error: collectionPath no es válido.');
    }
  }

  // Método para cargar y actualizar la lista de películas
  void _loadMovies() {
    final collectionReference =
        FirebaseFirestore.instance.collection(widget.collectionPath!);

    _moviesStream = collectionReference.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Movie.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Método para navegar a la pantalla de detalles de la película
  void _navigateToDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Películas'),
      ),
      body: StreamBuilder<List<Movie>>(
        stream: _moviesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No hay películas disponibles.');
          } else {
            return Container(
              height:
                  300, // Ajusta la altura de cada elemento según sea necesario
              child: ListView.builder(
                scrollDirection:
                    Axis.horizontal, // Establece la dirección horizontal
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _navigateToDetails(movie);
                      },
                      child: Column(
                        children: [
                          // Aquí está la imagen de la película
                          Image.network(
                            movie.image,
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8),
                          // Aquí está el título de la película
                          Text(
                            movie.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
