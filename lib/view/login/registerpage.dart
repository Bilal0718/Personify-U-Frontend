import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personifyu/common_widget/my_button.dart';
import 'package:personifyu/common_widget/my_textfields.dart';
import 'package:personifyu/common_widget/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personifyu/view/home/home_page.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      barrierDismissible: false,
    );

    if (nameController.text.isEmpty) {
      //Show error message for Name
      Navigator.pop(context);
      showErrorMessage('Name cannot be empty');
      return;
    }
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Navigator.pop(context);
      // Show error message for empty fields
      showErrorMessage("Email and Password cannot be empty");
      return;
    }

    // Try creating the user
    try {
      //check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        //add user details
        addUserDetails(userCredential.user!.uid, nameController.text.trim(), emailController.text.trim());

        // Pop the loading circle
        Navigator.pop(context);

        // Navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // show error message, passwords don't match
        Navigator.pop(context);
        showErrorMessage('Passwords don\'t match!');
        return;
      }
    } on FirebaseAuthException catch (e) {
      // Pop the loading circle
      Navigator.pop(context);

      // Print error to console for debugging
      print('Failed with error code: ${e.code}');
      print(e.message);

      // Show error message
      if (e.code == 'invalid-email') {
        // Show error to user
        wrongEmailMessage();
      } else if (e.code == 'invalid-credential') {
        // Show error to user
        wrongPasswordMessage();
      } else {
        // Show generic error message
        showErrorMessage("Authentication failed. Please try again.");
      }
    }
  }

  Future addUserDetails(String uid, String name, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'Name': name,
      'Email': email,
    });
  }

  // Generic error message pop-up
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // Wrong email message pop-up
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // Wrong password message pop-up
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/background.png',
              width: media.width,
              height: media.height,
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    //logo
                    Image.asset(
                      "assets/images/personify_u_logo.png",
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //Lets create an Account for you!
                    const Text(
                      'Let\'s create an Account for you!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyTextField(
                      controller: nameController,
                      hintText: 'Name',
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 10,
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
                    //confirm password textfield
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //forgot password
                    const SizedBox(
                      height: 25,
                    ),
                    //signin buttin
                    MyButton(text: "Sign Up", onTap: signUserUp),
                    const SizedBox(
                      height: 25,
                    ),
                    //or continue with
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Login now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
