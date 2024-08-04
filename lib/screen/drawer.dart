import 'package:flutter/material.dart';
import 'package:geotest/const/Colours.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AllColours.backgroundcolor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              'Employee E122',
              style: GoogleFonts.poppins(color: Colors.black),
            ),
            accountEmail: Text('employee e122@gmail.com',
                style: GoogleFonts.poppins(color: Colors.black)),
            currentAccountPicture: CircleAvatar(
              child: Center(
                child: Text(
                  "E",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            decoration: const BoxDecoration(),
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // Add more ListTile widgets here
        ],
      ),
    );
  }
}
