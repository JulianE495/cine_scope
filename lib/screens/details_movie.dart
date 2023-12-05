// details_movie.dart
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  MovieDetailsScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la pelicula'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Use CachedNetworkImage for efficient caching
          CachedNetworkImage(
            imageUrl: movie.image,
            height: 350,
            width: double.infinity,
            fit: BoxFit.contain,
            errorWidget: (context, url, error) => Center(
              child: Text('Failed to load image'),
            ),
          ),
          SizedBox(
              height: 16), // Add some space between the image and other details
          Text('Titulo: ${movie.title}', style: TextStyle(fontSize: 24)),
          Text('Director: ${movie.director}', style: TextStyle(fontSize: 24)),
          Text('Año: ${movie.year}', style: TextStyle(fontSize: 24)),
          // Add more details as needed
        ],
      ),
    );
  }
}
