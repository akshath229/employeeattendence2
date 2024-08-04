import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geotest/const/Colours.dart';
import 'package:geotest/widgets.dart/leave_list_view.dart'; // Corrected import path
import 'package:google_fonts/google_fonts.dart';
import 'apply_leave_page.dart'; // Import the ApplyLeavePage

class Leavemarker extends StatefulWidget {
  const Leavemarker({super.key});

  @override
  State<Leavemarker> createState() => _LeavemarkerState();
}

class _LeavemarkerState extends State<Leavemarker>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  List<Map<String, String>> leaveApplications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addLeaveApplication(String date, String notes) {
    setState(() {
      leaveApplications.add({'date': date, 'notes': notes});
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leave',
          style: GoogleFonts.poppins(
              color: AllColours.black,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        bottom: TabBar(
          unselectedLabelColor: AllColours.black3,
          labelStyle: GoogleFonts.poppins(),
          labelColor: AllColours.primaryColour,
          indicatorColor: AllColours.primaryColour,
          indicatorSize: TabBarIndicatorSize.tab,
          overlayColor:
              const WidgetStatePropertyAll(AllColours.primaryColourTwo),
          dividerColor: AllColours.grey2,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'All',
            ),
            Tab(
              text: 'Approved',
            ),
            Tab(
              text: 'Rejected',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02, vertical: 10),
            child: ReusableListView(
                items: leaveApplications
                    .map(
                        (leave) => '${leave['date']}, Notes: ${leave['notes']}')
                    .toList()),
          ),
          const Center(child: Text('Tab 2 Content')),
          const Center(child: Text('Tab 3 Content')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AllColours.primaryColour,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(
          FontAwesomeIcons.plus,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApplyLeavePage(
                onApply: _addLeaveApplication,
              ),
            ),
          );
        },
      ),
    );
  }
}
