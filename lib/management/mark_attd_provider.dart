import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotest/api/attendance_api.dart';
import 'package:geotest/const/Colours.dart';
import 'package:geotest/management/attend_detail.dart';
import 'package:geotest/service/getlocation.dart';
import 'package:geotest/widgets.dart/textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'dart:async';

final attendenceApiProvider = Provider((ref) => AttendenceAPI());
final locationServiceProvider = Provider((ref) => LocationService());

class AttendanceState {
  final bool isLoading;
  final String loadingMessage;
  final String checkInTime;
  final String checkOutTime;
  final String totalHours;
  final bool isCheckedIn;
  final bool isOnBreak;
  final DateTime? checkInDateTime;
  final DateTime? checkOutDateTime;
  final DateTime? breakStartTime;
  final Duration breakDuration;
  final List<Map<String, String>> attendanceRecords;

  AttendanceState({
    this.isLoading = false,
    this.loadingMessage = 'Getting your location',
    this.checkInTime = '--/--',
    this.checkOutTime = '--/--',
    this.totalHours = '00:00',
    this.isCheckedIn = false,
    this.isOnBreak = false,
    this.checkInDateTime,
    this.checkOutDateTime,
    this.breakStartTime,
    this.breakDuration = Duration.zero,
    this.attendanceRecords = const [],
  });

  AttendanceState copyWith({
    bool? isLoading,
    String? loadingMessage,
    String? checkInTime,
    String? checkOutTime,
    String? totalHours,
    bool? isCheckedIn,
    bool? isOnBreak,
    DateTime? checkInDateTime,
    DateTime? checkOutDateTime,
    DateTime? breakStartTime,
    Duration? breakDuration,
    List<Map<String, String>>? attendanceRecords,
  }) {
    return AttendanceState(
      isLoading: isLoading ?? this.isLoading,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      totalHours: totalHours ?? this.totalHours,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      isOnBreak: isOnBreak ?? this.isOnBreak,
      checkInDateTime: checkInDateTime ?? this.checkInDateTime,
      checkOutDateTime: checkOutDateTime ?? this.checkOutDateTime,
      breakStartTime: breakStartTime ?? this.breakStartTime,
      breakDuration: breakDuration ?? this.breakDuration,
      attendanceRecords: attendanceRecords ?? this.attendanceRecords,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final AttendenceAPI attendenceAPI;
  final LocationService locationService;

  AttendanceNotifier(this.attendenceAPI, this.locationService)
      : super(AttendanceState()) {
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _clearSharedPreferencesOnFirstLaunch();
    await _loadCheckInTime();
    await _loadCheckOutTime();
  }

  Future<void> _clearSharedPreferencesOnFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if this is the first launch
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // Clear the preferences if it's the first launch
      await prefs.clear();

      // Set the flag to false as the app has now been launched at least once
      await prefs.setBool('isFirstLaunch', false);
    }
  }

  Future<void> _loadCheckInTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final checkInTime = prefs.getString('checkInTime') ?? '--/--';
    final isCheckedIn = checkInTime != '--/--';
    final checkInDateTime = isCheckedIn
        ? DateTime.tryParse(prefs.getString('checkInDateTime') ?? '')
        : null;

    // Load the check-out time to determine if the user checked out
    final checkOutTime = prefs.getString('checkOutTime') ?? '--/--';

    state = state.copyWith(
      checkInTime: checkInTime,
      isCheckedIn: isCheckedIn && checkOutTime == '--/--',
      checkInDateTime: checkInDateTime,
    );
  }

  Future<void> _loadCheckOutTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final checkOutTime = prefs.getString('checkOutTime') ?? '--/--';
    final checkOutDateTime = checkOutTime != '--/--'
        ? DateTime.tryParse(prefs.getString('checkOutDateTime') ?? '')
        : null;

    // If checkout time is not '--/--', the user has checked out, so reset isCheckedIn to false
    if (checkOutTime != '--/--') {
      state = state.copyWith(
        checkInTime: '--/--',
        checkInDateTime: null,
        isCheckedIn: false,
      );
    }

    state = state.copyWith(
      checkOutTime: checkOutTime,
      checkOutDateTime: checkOutDateTime,
    );
  }

  Future<void> _saveCheckInTime(
      String checkInTime, DateTime checkInDateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('checkInTime', checkInTime);
    await prefs.setString('checkInDateTime', checkInDateTime.toIso8601String());
  }

  Future<void> _saveCheckOutTime(
      String checkOutTime, DateTime checkOutDateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('checkOutTime', checkOutTime);
    await prefs.setString(
        'checkOutDateTime', checkOutDateTime.toIso8601String());
  }

  Future<void> markAttendance(BuildContext context, WidgetRef ref) async {
    final attendenceRecords = ref.watch(attendsDetailsApiProvider);

    // Show a dialog to input empcode
    String empcode = await _showEmpCodeDialog(context);

    if (empcode.isEmpty) {
      // If the user cancels or doesn't enter any code, do nothing
      return;
    }

    state = state.copyWith(
        isLoading: true, loadingMessage: 'Getting your location');

    // Show the loading bottom sheet
    showLoadingBottomSheet(context, state.loadingMessage);

    try {
      Position position = await locationService.getGeoLocationPosition();
      Map<String, String> addressDetails =
          await locationService.getAddressFromLatLong(position);

      DateTime now = DateTime.now();
      String date = now.toIso8601String().split('T')[0]; // YYYY-MM-DD
      TimeOfDay currentTime = TimeOfDay.now();
      String formattedTime =
          currentTime.format(context); // Format time as HH:MM

      Map<String, dynamic> requestBody = {
        "compcode": "Vipul",
        "empcode": empcode,
        "mobile_number": "9810920364",
        "longitude": position.longitude.toString(),
        "latitude": position.latitude.toString(),
        "floor": "1",
        "address": addressDetails['fullAddress'],
        "street": addressDetails['street'],
        "sublocality": addressDetails['subLocality'],
        "locality": addressDetails['locality'],
        "date": date,
        "time": formattedTime,
        "present": "1",
        "checktype": "O" // checkin- I ,checkout -O ,break- B,
      };

      state = state.copyWith(loadingMessage: 'Marking attendance');

      String response = await attendenceAPI.sendPostRequest(requestBody);

      state = state.copyWith(
        checkInTime: formattedTime,
        checkInDateTime: now,
        isCheckedIn: true,
        checkOutTime: '--/--',
        totalHours: '00:00',
      );

      await _saveCheckInTime(formattedTime, now);
      await _saveCheckOutTime('--/--', DateTime.now());

      _showMessage(context, 'Attendance marked successfully');
      final attendanceRecordsNotifier =
          ref.read(attendsDetailsApiProvider.notifier);
      await attendanceRecordsNotifier.attendanceRecord(
          context, "Vipul", empcode, "D");
    } finally {
      state = state.copyWith(isLoading: false);
      Navigator.pop(context);
    }
  }

//  state = state.copyWith(
//         checkInTime: formattedTime,
//         checkInDateTime: now,
//         isCheckedIn: true,
//         checkOutTime: '--/--',
//         totalHours: '00:00',
//       );

//       await _saveCheckInTime(formattedTime, now);
//       await _saveCheckOutTime('--/--', DateTime.now());

//       _showMessage(context, 'Attendance marked successfully');
//       final attendanceRecordsNotifier =
//           ref.read(attendsDetailsApiProvider.notifier);
//       await attendanceRecordsNotifier.attendanceRecord(
//           context, "Vipul", empcode, "D");
//     } catch (e) {
//       _showMessage(context, 'Error marking attendance');
//     } finally {
//       state = state.copyWith(isLoading: false);
//       Navigator.pop(context);
//     }
//   }

  Future<String> _showEmpCodeDialog(BuildContext context) async {
    TextEditingController empCodeController = TextEditingController();
    String empCode = '';

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AllColours.backgroundcolor,
          content: TextFieldWidget(
            controller: empCodeController,
            hintText: "Enter your empcode",
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: GoogleFonts.poppins(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit',
                  style: GoogleFonts.poppins(color: Colors.black)),
              onPressed: () {
                empCode = empCodeController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return empCode;
  }

  void showLoadingBottomSheet(
      BuildContext context, String loadingMessage) async {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 250,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.grey.shade400,
                        size: 50,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        loadingMessage,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> markCheckout(BuildContext context) async {
    DateTime now = DateTime.now();
    String formattedTime = TimeOfDay.now().format(context);

    state = state.copyWith(
      checkOutTime: formattedTime,
      checkOutDateTime: now,
      isCheckedIn: false,
    );

    _calculateTotalHours();

    state = state.copyWith(
      attendanceRecords: [
        ...state.attendanceRecords,
        {
          'checkIn': state.checkInTime,
          'checkOut': formattedTime,
          'totalHours': state.totalHours,
        },
      ],
    );

    await _saveCheckOutTime(formattedTime, now);

    _showMessage(context, 'Checked out successfully');
  }

  Future<void> takeBreak(BuildContext context) async {
    state = state.copyWith(
      isOnBreak: true,
      breakStartTime: DateTime.now(),
    );

    Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(
        breakDuration: DateTime.now().difference(state.breakStartTime!),
      );
    });

    _showMessage(context, 'Break started successfully');
  }

  Future<void> endBreak(BuildContext context) async {
    state = state.copyWith(
      isOnBreak: false,
      breakDuration: Duration.zero,
    );

    _showMessage(context, 'Break ended successfully');
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _calculateTotalHours() {
    if (state.checkInDateTime != null && state.checkOutDateTime != null) {
      Duration totalDuration =
          state.checkOutDateTime!.difference(state.checkInDateTime!);
      state = state.copyWith(
        totalHours: _formatDuration(totalDuration),
      );
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  final attendenceAPI = ref.watch(attendenceApiProvider);
  final locationService = ref.watch(locationServiceProvider);
  return AttendanceNotifier(attendenceAPI, locationService);
});
