import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rehuddle/screens/main_screens/home_screen.dart';
import 'package:rehuddle/screens/main_screens/profile_screen.dart';
import 'package:rehuddle/utils/constants.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: GNav(
        tabMargin: EdgeInsets.all(10),
          gap: 8,
          backgroundColor: themeColor,
          color: kwhiteColor,
          activeColor: themeColor,
          tabBackgroundColor: kBackGroundColor,
          padding: const EdgeInsets.all(10),
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
          
           
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
        ),
    );
  }
}