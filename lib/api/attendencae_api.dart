// api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendenceAPI {
  static const String url = 'http://122.176.114.77/UTSHR_Attend/api/values';

  Future<String> sendPostRequest(Map<String, dynamic> requestBody) async {
    var headers = {
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode(requestBody);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      throw Exception('Failed to send request: ${response.reasonPhrase}');
    }
  }
}






  //   return Padding(
    //     padding: const EdgeInsets.all(12), // 2% of screen width
    //     child: SingleChildScrollView(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "Welcome",
    //                 style: GoogleFonts.inter(
    //                     fontWeight: FontWeight.w300,
    //                     fontSize: screenWidth * 0.04), // 4% of screen width
    //               ),
    //               Text(
    //                 "Employee E122",
    //                 style: GoogleFonts.inter(
    //                     fontWeight: FontWeight.w600,
    //                     fontSize: screenWidth * 0.06), // 6% of screen width
    //               ),
    //             ],
    //           ),
    //           SizedBox(
    //             height: verticalPadding, // Dynamic vertical spacing
    //           ),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "Today's Status",
    //                 style: GoogleFonts.inter(
    //                     fontWeight: FontWeight.w500,
    //                     fontSize: screenWidth * 0.05), // 5% of screen width
    //               ),
    //               SizedBox(
    //                 height: screenHeight * 0.0001, // Dynamic spacing
    //               ),
    //               Card(
    //                 color: Colors.white,
    //                 elevation: 3,
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(
    //                       screenWidth * 0.03), // 3% of screen width
    //                 ),
    //                 margin: EdgeInsets.symmetric(
    //                     vertical: verticalPadding,
    //                     horizontal: screenHeight * 0.0001),
    //                 child: SizedBox(
    //                   width: containerWidth,
    //                   height: containerHeight,
    //                   child: Padding(
    //                     padding:
    //                         EdgeInsets.symmetric(vertical: screenHeight * 0.08),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Column(
    //                               children: [
    //                                 Text(
    //                                   "Check In",
    //                                   style: GoogleFonts.inter(),
    //                                 ),
    //                                 Text(_checkInTime,
    //                                     style: GoogleFonts.inter(
    //                                         color: Colors.green.shade300)),
    //                               ],
    //                             ),
    //                             SizedBox(width: screenHeight * 0.08),
    //                             Column(
    //                               children: [
    //                                 Text(
    //                                   "Check Out",
    //                                   style: GoogleFonts.inter(),
    //                                 ),
    //                                 Text("--/--", style: GoogleFonts.inter()),
    //                               ],
    //                             ),
    //                           ],
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 width: containerWidth,
    //                 height: screenHeight * 0.06,
    //                 child: ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                     backgroundColor: Colors.red,
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(10),
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     _markAttendance(context);
    //                   },
    //                   child: Center(
    //                     child: Text(
    //                       "Mark Attendance",
    //                       style: GoogleFonts.inter(
    //                           fontWeight: FontWeight.w600, color: Colors.white),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
  