import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personifyu/view/home/home_page.dart';
import 'package:personifyu/view/login/welcome_view.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure locale is set for Firebase
    String? locale = Localizations.localeOf(context).languageCode;
    if (locale != null) {
      FirebaseAuth.instance.setLanguageCode(locale);
    } else {
      FirebaseAuth.instance.setLanguageCode('en'); // Default to English if locale is null
    }

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check connection state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // User is logged in
          if (snapshot.hasData) {
            return HomePage();
          }

          // User is NOT logged in
          else {
            return WelcomeView();
          }
        },
      ),
    );
  }
}
