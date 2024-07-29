import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:personifyu/common/color_extension.dart';
import 'package:personifyu/common_widget/my_button.dart';
import 'package:personifyu/view/home/career_search.dart';
import 'package:personifyu/view/home/chat_page.dart';
import 'package:personifyu/view/home/profile.dart';
import 'package:personifyu/view/login/login_or_register_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void navigationToPages(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void ChatRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage()),
    );
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
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('LOGGED IN AS: ${user?.email ?? 'Unknown'}'),
                MyButton(text: "Chat", onTap: ChatRoute),
              ],
            ),
          ),
          CareerSearch(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        color: TColor.OrangeTheme,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: TColor.OrangeTheme,
            tabBorderRadius: 100.0,
            duration: Duration(milliseconds: 300),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.black,
            padding: EdgeInsets.all(16),
            gap: 8,
            onTabChange: navigationToPages,
            selectedIndex: _selectedIndex,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.person_search,
                text: 'Career Search',
              ),
              GButton(
                icon: Icons.account_circle,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
