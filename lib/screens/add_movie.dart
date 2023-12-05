import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../movie.dart';

class AddMovieScreen extends StatefulWidget {
  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  final CollectionReference moviesCollection =
      FirebaseFirestore.instance.collection('movies');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Película'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _directorController,
                decoration: InputDecoration(labelText: 'Director'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el director';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Año'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el año';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'URL de la imagen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la URL de la imagen';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _saveMovie();
                  }
                },
                child: Text('Guardar Película'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveMovie() async {
    if (_formKey.currentState?.validate() ?? false) {
      Movie newMovie = Movie(
        title: _titleController.text,
        director: _directorController.text,
        year: int.parse(_yearController.text),
        image: _imageController.text,
      );

      try {
        await moviesCollection.add(newMovie.toMap());

        // Limpiar los campos del formulario
        _titleController.clear();
        _directorController.clear();
        _yearController.clear();
        _imageController.clear();

        // Mostrar un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Película guardada correctamente'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Error al guardar la película: $e');

        // Puedes mostrar un mensaje de error en caso de que ocurra un problema
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error al guardar la película. Por favor, intenta nuevamente.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
