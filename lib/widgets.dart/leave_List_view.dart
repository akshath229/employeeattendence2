import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableListView extends StatelessWidget {
  final List<String> items;

  const ReusableListView({
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white,
          elevation: 2,
          child: ListTile(
            trailing: Container(
              height: 30,
              width: screenWidth * 0.23,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.orangeAccent),
              child: Center(
                child: Text(
                  'Pending',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                ),
              ),
            ),
            subtitle: Text(
              '',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            title: Text(
              items[index],
              style: GoogleFonts.poppins(),
            ),
          ),
        );
      },
    );
  }
}
