import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter_firebase/screens/home/home_screen.dart';
import 'package:todo_flutter_firebase/screens/login/login_screen.dart';
import 'package:todo_flutter_firebase/utils/loader_screen.dart';

enum AuthStatus {
  notDetermined,
  notLoggedIn,
  loggedIn,
}

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  AuthStatus authStatus = AuthStatus.notDetermined;

  String? _userId;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser().then((user) {
      if (user != null) {
        _userId = user.uid;
      }

      authStatus =
          _userId != null ? AuthStatus.loggedIn : AuthStatus.notLoggedIn;

      print('Estado de auth $authStatus');
      print('UserId $_userId');

      setState(() {});
    });
  }

  Future<User?> getCurrentUser() async => _auth.currentUser;

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return const LoaderScreen();
      case AuthStatus.notLoggedIn:
        return const LoginScreen();
      case AuthStatus.loggedIn:
        return HomeScreen(
          userId: _userId!,
        );
    }
  }
}
