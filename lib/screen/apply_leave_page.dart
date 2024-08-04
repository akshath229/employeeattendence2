import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ApplyLeavePage extends StatefulWidget {
  final Function(String, String) onApply;

  const ApplyLeavePage({required this.onApply, super.key});

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  DateTime? selectedDate;
  TextEditingController notesController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    String formattedDate = selectedDate == null
        ? 'Select date'
        : DateFormat('dd-MMMM-yyyy').format(selectedDate!);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Container(
          width: double.infinity,
          child: FloatingActionButton.small(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Text(
              'Apply',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            onPressed: () {
              if (selectedDate != null && notesController.text.isNotEmpty) {
                widget.onApply(DateFormat('dd-MMM-yyyy').format(selectedDate!),
                    notesController.text);
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Apply Leave',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(formattedDate),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
          ],
        ),
      ),
    );
  }
}
