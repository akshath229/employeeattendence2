import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geotest/screen/calenderpage.dart';
import 'package:geotest/screen/drawer.dart';
import 'package:geotest/screen/leavemarker.dart';
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
    Leavemarker(),
    LocationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Retrieve the screen dimensions
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    bool showAppBar = _selectedIndex != 2;

    return Scaffold(
      appBar: showAppBar ? AppBar() : null,
      drawer: const CustomDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            activeIcon: Icon(
              FontAwesomeIcons.house,
              color: Colors.black,
            ),
            icon: Icon(FontAwesomeIcons.house, color: Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            activeIcon:
                Icon(FontAwesomeIcons.solidCalendarDays, color: Colors.black),
            icon: Icon(
              FontAwesomeIcons.solidCalendarDays,
              color: Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            activeIcon:
                Icon(FontAwesomeIcons.calendarCheck, color: Colors.black),
            icon: Icon(FontAwesomeIcons.calendarCheck, color: Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            activeIcon: Icon(FontAwesomeIcons.locationDot, color: Colors.black),
            icon: Icon(FontAwesomeIcons.locationDot, color: Colors.grey),
            label: '',
          ),
        ],
      ),
    );
  }
}
