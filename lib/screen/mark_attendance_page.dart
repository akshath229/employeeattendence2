import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geotest/const/Colours.dart';
import 'package:geotest/management/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePageContent extends ConsumerStatefulWidget {
  const HomePageContent({super.key});

  @override
  createState() => _HomePageContentState();
}

class _HomePageContentState extends ConsumerState<HomePageContent> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final attendanceState = ref.watch(attendanceProvider);
    final attendanceNotifier = ref.read(attendanceProvider.notifier);

    // Calculate dynamic dimensions
    final containerWidth = screenWidth * 0.9; // 90% of screen width
    final containerHeight = screenHeight * 0.25; // 25% of screen height
    final textSpacing = screenWidth * 0.05; // 5% of screen width
    final verticalPadding = screenHeight * 0.03; // 5% of screen height

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: verticalPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  attendanceState.isOnBreak
                      ? Column(
                          children: [
                            Text(
                              "It's your break time",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            const Image(
                              height: 130,
                              width: 200,
                              image: AssetImage(
                                'lib/assets/mug_3100556 (1).png',
                              ),
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              _formatDuration(attendanceState.breakDuration),
                              style: GoogleFonts.poppins(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Your break started at ${DateFormat('hh:mm a').format(attendanceState.breakStartTime!)}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            ElevatedButton(
                              onPressed: () =>
                                  attendanceNotifier.endBreak(context),
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                padding: EdgeInsets.all(screenWidth * 0.05),
                                backgroundColor: AllColours.primaryColour,
                              ),
                              child: Text(
                                'End Break',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              DateFormat('hh:mm:ss a').format(_currentTime),
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: textSpacing),
                            Text(
                              DateFormat('d MMMM yyyy - EEEE')
                                  .format(DateTime.now()),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.1),
                            attendanceState.isCheckedIn
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => attendanceNotifier
                                            .markCheckout(context),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color:
                                                    AllColours.primaryColour),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          padding: EdgeInsets.all(
                                              screenWidth * 0.05),
                                          backgroundColor: Colors.white,
                                        ),
                                        child: Text(
                                          'Check Out',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AllColours.primaryColour,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.05),
                                      ElevatedButton(
                                        onPressed: () => attendanceNotifier
                                            .takeBreak(context),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          padding: EdgeInsets.all(
                                              screenWidth * 0.05),
                                          backgroundColor:
                                              AllColours.primaryColour,
                                        ),
                                        child: Text(
                                          'Take a Break',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.15),
                                    ],
                                  )
                                : Container(
                                    width: screenWidth * 0.6,
                                    height: screenHeight * 0.15,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () => attendanceNotifier
                                          .markAttendance(context),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 8,
                                        shape: const CircleBorder(),
                                        padding:
                                            EdgeInsets.all(screenWidth * 0.1),
                                        backgroundColor:
                                            AllColours.primaryColour,
                                      ),
                                      child: Text(
                                        'Check In',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
                    child: Divider(
                      endIndent: 10,
                      indent: 10,
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                size: 18,
                                FontAwesomeIcons.clockRotateLeft,
                                color: Colors.green,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(attendanceState.checkInTime,
                                  style:
                                      GoogleFonts.poppins(color: Colors.black)),
                              Text("Check In",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                size: 18,
                                FontAwesomeIcons.clockRotateLeft,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(attendanceState.checkOutTime,
                                  style:
                                      GoogleFonts.poppins(color: Colors.black)),
                              Text("Check Out",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                size: 18,
                                FontAwesomeIcons.clock,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(attendanceState.totalHours,
                                  style:
                                      GoogleFonts.poppins(color: Colors.black)),
                              Text("Total Hrs",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: attendanceState.attendanceRecords.length,
              itemBuilder: (context, index) {
                final record = attendanceState.attendanceRecords[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Card(
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "check in",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: AllColours.green,
                                ),
                              ),
                              Text(
                                "${record['checkIn']}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Column(
                            children: [
                              Text(
                                "check out",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: AllColours.red,
                                ),
                              ),
                              Text(
                                "${record['checkOut']}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
