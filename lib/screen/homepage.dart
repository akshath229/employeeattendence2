import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geotest/screen/calenderpage.dart';
import 'package:geotest/screen/drawer.dart';
import 'package:geotest/screen/locationpage.dart';
import 'package:geotest/screen/mark_attendance_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    HomePageContent(),
    CalendarPage(),
    LocationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Retrieve the screen dimensions
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(
              FontAwesomeIcons.house,
              color: Colors.black,
            ),
            icon: Icon(FontAwesomeIcons.house, color: Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon:
                Icon(FontAwesomeIcons.calendarCheck, color: Colors.black),
            icon: Icon(
              FontAwesomeIcons.calendarCheck,
              color: Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(FontAwesomeIcons.locationDot, color: Colors.black),
            icon: Icon(FontAwesomeIcons.locationDot, color: Colors.grey),
            label: '',
          ),
        ],
      ),
    );
  }
}
