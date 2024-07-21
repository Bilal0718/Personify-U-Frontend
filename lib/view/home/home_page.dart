import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:personifyu/common/color_extension.dart';
import 'package:personifyu/view/home/career_search.dart';
import 'package:personifyu/view/home/profile.dart';
import 'package:personifyu/view/login/login_or_register_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  void navigationToPages(index){
    if (index ==0){
      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
    }else if(index == 1){
      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CareerSearch()),
  );

    }else if(index == 2){
      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Profile()),
  );
  }
  } 


  // Sign user out method
  void signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginOrRegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text('LOGGED IN AS: ${user?.email ?? 'Unknown'}'),
      ),
      bottomNavigationBar: Container(
        color: TColor.OrangeTheme,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: TColor.OrangeTheme,
            tabBorderRadius:  100.0,
            duration: Duration(milliseconds: 300),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.black,
            padding: EdgeInsets.all(16),
            gap: 8,
            onTabChange: navigationToPages,
            tabs: [GButton(icon: Icons.home,
            text: 'Home',),
            GButton(icon: Icons.person_search,
            text: 'Career Search',),
            GButton(icon: Icons.account_circle,
            text: 'Profile',),
            ]
            ),
        ),
      ),
    );
  }
}
