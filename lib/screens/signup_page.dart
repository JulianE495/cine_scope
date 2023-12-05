import 'package:cine_scope/screens/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late String email, password, username, profileImage;
  final _formKey = GlobalKey<FormState>();
  String error = '';

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
              'Registro',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          Offstage(
            offstage: error == '',
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(error, style: TextStyle(color: Colors.red)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: _buildLoginForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailField(),
          _buildUsernameField(),
          _buildPasswordField(),
          _buildProfileImageField(),
          SizedBox(height: 16),
          _buildSignupButton(),
          _builSigninLink(),
        ],
      ),
    );
  }

  Widget _builSigninLink() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: const Text('Ya tienes cuenta? Inicia sesión'),
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
          return 'Debes ingresar un correo electronico';
        }
        return null;
      },
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Nombre de Usuario',
      ),
      onSaved: (String? value) {
        username = value!;
      },
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Debes ingresar un nombre de usuario';
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

  Widget _buildProfileImageField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'URL de la imagen de perfil',
      ),
      keyboardType: TextInputType.url,
      onSaved: (String? value) {
        profileImage = value!;
      },
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Debes ingresar la URL de la imagen de perfil';
        }
        return null;
      },
    );
  }

  Widget _buildSignupButton() {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            UserCredential? credenciales = await signup(
              email,
              password,
              username,
              profileImage,
              (errorMessage) {
                setState(() {
                  error = errorMessage;
                });
              },
            );
            if (credenciales != null) {
              if (credenciales.user != null) {
                await credenciales.user!.sendEmailVerification();
                Navigator.of(context).pop();
                print("Registro exitoso");
              }
            } else {
              error =
                  "Debes verificar tu correo"; // mostrar error de verificación
            }
          }
        },
        child: const Text('Registrarse'),
      ),
    );
  }
}

Future<UserCredential?> signup(
  String email,
  String password,
  String username,
  String profileImage,
  Function onError,
) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    // Update Firestore with additional user information
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'username': username,
      'profileImage': profileImage,
      'email': email,
    });
    return userCredential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      onError('The account already exists for that email.');
    } else if (e.code == 'weak-password') {
      onError('The password provided is too weak.');
    }
  } catch (e) {
    print(e.toString());
  }
}
