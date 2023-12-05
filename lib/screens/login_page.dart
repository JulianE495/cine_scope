import 'package:cine_scope/screens/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  late String email, password;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Inicio de Sesión',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(error, style: TextStyle(color: Colors.red)),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: _buildLoginForm(),
            )
          ]),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailField(),
          _buildPasswordField(),
          SizedBox(height: 16),
          _buildLoginButton(),
          _builSignupLink(),
        ],
      ),
    );
  }

  Widget _builSignupLink() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Signup()),
        );
      },
      child: const Text('Aún no tienes cuenta? Regístrate aquí'),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Correo Electronico',
      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String? value) {
        email = value!;
      },
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Debes ingresar un email';
        }

        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Contraseña',
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      onSaved: (String? value) {
        password = value!;
      },
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Debes ingresar una contraseña';
        }

        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: ElevatedButton(
        onPressed: () async {
          print("Presionaste el botón de inicio de sesión");
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            try {
              UserCredential userCredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);

              // Dentro de la clase _LoginState en _buildLoginButton
              if (userCredential.user != null) {
                try {
                  // Fetch user data from Firestore based on the email
                  QuerySnapshot userQuery = await FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: email)
                      .get();

                  if (userQuery.docs.isNotEmpty) {
                    // Access the username and photo URL from the first document in the query result
                    String username = userQuery.docs.first['username'];
                    String photoUrl = userQuery.docs.first['profileImage'];

                    // Navegar a la página de inicio
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          nombreUsuario: username,
                          correoElectronico: email,
                          fotoPerfil: photoUrl,
                        ),
                      ),
                    );
                  } else {
                    // Handle the case where no matching document is found
                    print("No matching user document found.");
                  }
                } catch (e) {
                  print("Error fetching user data: $e");
                  // Handle the error, show an appropriate message, etc.
                }
              } else {
                // Mostrar un error
                error = "Debes verificar tu correo electrónico";
              }
            } on FirebaseAuthException catch (e) {
              // Manejar errores de autenticación
              print("Error de autenticación: ${e.message}");
            } catch (e) {
              // Manejar otros errores
              print("Error desconocido: $e");
            }
            print("Después de la autenticación");
          }
        },
        child: const Text('Iniciar Sesión'),
      ),
    );
  }
}
