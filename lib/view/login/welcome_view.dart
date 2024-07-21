import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personifyu/view/login/login_or_register_page.dart';
import '/common_widget/round_button.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset('assets/images/background.png',
              width: media.width, height: media.height, fit: BoxFit.cover),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "KNOW YOURSELF",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "personify ",
                      style: TextStyle(
                          color: Color(0xff00252F),
                          fontSize: 40,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "yourself",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "A place to know who you are,what you can\nbecome and what you can achieve.",
                        style: TextStyle(
                            color: const Color(0xffFCFCFC).withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RoundButton(
                      title: "Personify Me!",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginOrRegisterPage()));
                      }),
                ),
                const SizedBox(
                  height: 90,
                ),
                Image.asset(
                  "assets/images/personify_u_logo.png",
                  width: 147,
                  height: 158,
                ),
                const SizedBox(
                  height: 46,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
