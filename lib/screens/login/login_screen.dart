import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter_firebase/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorMesssage;

  bool? _isLoading;
  bool? _isLoginForm;

  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    _errorMesssage = '';
    _isLoading = false;
    _isLoginForm = false;
  }

  toggleFormMode() {
    setState(() {
      _isLoginForm = !_isLoginForm!;
    });
  }

  void submit() async {
    setState(() {
      _errorMesssage = '';
      _isLoading = true;
    });

    if (validateForm()) {
      UserCredential user;
      String userId = '';

      try {
        if (!_isLoginForm!) {
          user = await _auth.createUserWithEmailAndPassword(
            email: _email!,
            password: _password!,
          );

          print('Creacion de usuario');
        } else {
          user = await _auth.signInWithEmailAndPassword(
            email: _email!,
            password: _password!,
          );
          print('Login de usuario');
        }

        userId = user.user!.uid;

        print(userId);

        setState(() {
          _isLoading = false;
        });

        if (userId.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(userId: userId),
            ),
          );
        }
      } catch (error) {
        print('Error $error');

        setState(() {
          _isLoading = false;
          _errorMesssage = error.toString();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool validateForm() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticación'),
      ),
      body: Stack(
        children: [
          _showForm(),
          _showCircularProggres(),
        ],
      ),
    );
  }

  _showCircularProggres() {
    if (_isLoading!) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return const SizedBox();
  }

  Widget _showForm() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const FlutterLogo(
              size: 150,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextFormField(
                enabled: !_isLoading!,
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                decoration: const InputDecoration(
                  hintText: 'Correo',
                  icon: Icon(
                    Icons.mail,
                    color: Colors.grey,
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
                onSaved: (value) => _email = value!.trim(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextFormField(
                enabled: !_isLoading!,
                maxLines: 1,
                obscureText: true,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: const InputDecoration(
                  hintText: 'Contraseña',
                  icon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
                onSaved: (value) => _password = value!.trim(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: _isLoading! ? null : submit,
                child: Text(
                  !_isLoginForm! ? 'Crear' : 'Login',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            TextButton(
              onPressed: _isLoading! ? null : toggleFormMode,
              child: Text(
                !_isLoginForm! ? 'O iniciar sesión' : 'O crear cuenta',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            (_errorMesssage != null && _errorMesssage!.isNotEmpty)
                ? Text(
                    _errorMesssage!,
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Colors.red,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
