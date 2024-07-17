import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personifyu/view/home/home_page.dart';
import 'package:personifyu/view/login/welcome_view.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {          
            if (snapshot.hasData && snapshot.data != null) {
              // User is signed in
              return HomePage();
            } else {
              // User is not signed in
              return const WelcomeView();
            }
        },
      ),
    );
  }
}

