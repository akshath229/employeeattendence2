import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotest/api/attendance_api.dart';
import 'package:geotest/models/empolyee.dart';

final attendDetailsApiProvider = Provider((ref) => AttendenceAPI());

class AttendanceRecordState {
  final bool isLoading;
  final String loadingMessage;
  final String responseMessage;
  final List<Employee> attendanceRecords;

  AttendanceRecordState({
    this.isLoading = false,
    this.loadingMessage = 'Processing...',
    this.responseMessage = '',
    this.attendanceRecords = const [],
  });

  AttendanceRecordState copyWith({
    bool? isLoading,
    String? loadingMessage,
    String? responseMessage,
    List<Employee>? attendanceRecords,
  }) {
    return AttendanceRecordState(
      isLoading: isLoading ?? this.isLoading,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      responseMessage: responseMessage ?? this.responseMessage,
      attendanceRecords: attendanceRecords ?? this.attendanceRecords,
    );
  }
}

class AttendanceRecordNotifier extends StateNotifier<AttendanceRecordState> {
  final AttendenceAPI attendenceAPI;

  AttendanceRecordNotifier(this.attendenceAPI) : super(AttendanceRecordState());

  Future<void> attendanceRecord(BuildContext context,
      String compcode, String empcode, String attday) async {
    state = state.copyWith(isLoading: true);

    try {
      Map<String, dynamic> requestBody = {
        "compcode": compcode,
        "empcode": empcode,
        "attday": attday,
      };

      String response = await attendenceAPI.sendPostRequest(requestBody);

      // Decode response and map to Employee objects
      List<dynamic> decodedResponse = json.decode(response);
      List<Employee> attendanceRecords =
          decodedResponse.map((json) => Employee.fromJson(json)).toList();

      state = state.copyWith(
        isLoading: false,
        attendanceRecords: attendanceRecords,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        responseMessage: 'Error: $e',
      );
    }
  }
}

final attendsDetailsApiProvider =
    StateNotifierProvider<AttendanceRecordNotifier, AttendanceRecordState>(
        (ref) {
  final attendDetailAPI = ref.watch(attendDetailsApiProvider);
  return AttendanceRecordNotifier(attendDetailAPI);
});

// class AttendancePage extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final attendanceState = ref.watch(attendanceProvider);
//     final attendanceNotifier = ref.read(attendanceProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mark Attendance'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             if (attendanceState.isLoading)
//               CircularProgressIndicator()
//             else
//               ElevatedButton(
//                 onPressed: () async {
//                   await attendanceNotifier.markAttendance(
//                       'Vipul', 'VIDL-001', 'm');

//                   final responseMessage =
//                       ref.read(attendanceProvider).responseMessage;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Response: $responseMessage')),
//                   );
//                 },
//                 child: Text('Mark Attendance'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(ProviderScope(child: MaterialApp(home: AttendancePage())));
// }
