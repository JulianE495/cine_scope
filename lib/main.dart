import 'package:cine_scope/firebase_options.dart';
import 'package:cine_scope/screens/list_movies.dart';
import 'package:cine_scope/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Tu pantalla principal aquí
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación con Firebase'),
      ),
      body: Center(
        child: Text('Hola, Firebase!'),
      ),
    );
  }
}
