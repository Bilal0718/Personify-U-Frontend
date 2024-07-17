import 'package:flutter/material.dart';
import 'package:personifyu/common_widget/my_button.dart';
import 'package:personifyu/common_widget/my_textfields.dart';
import 'package:personifyu/common_widget/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {

    //show loading Circle
    showDialog(context: context, builder: (context){
      return Center(child: CircularProgressIndicator(),
      );
    },
    barrierDismissible: false,
    );
    //try sigin
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailController.text,
    password: passwordController.text,

    
    );
    //pop the loading circle
    Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);
      //WRONG EMAIL
      if (e.code == 'user-not-found'){
        //show error to user
        wrongEmailMessage();
      }
      //WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        //show error to user
        wrongPasswordMessage();
      }

    }


  }

  //wrong email message pop-up
  void wrongEmailMessage(){
    showDialog(context: context, builder: (context){
      return const AlertDialog(title: Text('Incorrect Email'),);
    });
  }

  //wrong password message pop-up
  void wrongPasswordMessage(){
    showDialog(context: context, builder: (context){
      return const AlertDialog(title: Text('Incorrect Password'),);
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(children: [
            Image.asset('assets/images/background.png',
                width: media.width, height: media.height, fit: BoxFit.cover),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    //logo
                    Image.asset(
                      "assets/images/personify_u_logo.png",
                      width: 200,
                      height: 200,
                    ),
          
                    const SizedBox(
                      height: 10,
                    ),
                    //welcome back,  you've been missed!
                    const Text(
                      'Welcome back, you\'ve been missed!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //email textfield
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //password textfield
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //forgot password
                    const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //signin buttin
                    MyButton(onTap: signUserIn),
                    const SizedBox(
                      height: 50,
                    ),
                    //or continue with
                    const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // google button
                        SquareTile(imagePath: 'assets/images/google.png'),
          
                        SizedBox(width: 25),
          
                        // apple button
                        SquareTile(imagePath: 'assets/images/apple.png'),
                      ],
                    ),
                    const SizedBox(width: 20),
                    //not a member register now
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not a ember?',
                        style: TextStyle(color: Colors.black),),
                        SizedBox(width: 4,),
                        Text('Register now',
                        style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ))
                      ],
                    )
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
