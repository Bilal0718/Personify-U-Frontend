import 'package:flutter/material.dart';
import 'package:personifyu/view/login/auth_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireOpenApp();
  }

  void fireOpenApp() async {
    await Future.delayed(const Duration(seconds: 3));
    startApp();
  }

  void startApp() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AuthPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: 
          Center(
            child: Image.asset(
              "assets/images/personify_u_logo.png",
              width: media.width * 0.7,
            ),
          )
    );
  }
}
