import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geotest/service/getlocation.dart';
import 'package:geotest/widgets.dart/textfield.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String location = 'Press button';
  String address = 'Press button';
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _CompanycodeController = TextEditingController();
  final TextEditingController _empCodeController = TextEditingController();
  bool isLoading = false;
  final LocationService locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Address',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Coordinates Points',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Text(
                location,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Address',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Text(
                address,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
                  textStyle: WidgetStateProperty.all(GoogleFonts.poppins()),
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  Position position =
                      await locationService.getGeoLocationPosition();
                  location =
                      'Lat: ${position.latitude} , Long: ${position.longitude}';
                  Map<String, String> address =
                      await locationService.getAddressFromLatLong(position);

                  setState(() {
                    isLoading = false;
                  });
                },
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      )
                    : const Text('Get Location'),
              ),
              const SizedBox(height: 30),
              const Text(
                'Company',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _CompanycodeController,
                decoration: InputDecoration(
                  labelText: 'Company code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _empCodeController,
                decoration: InputDecoration(
                  labelText: 'Emp code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _latitudeController,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _longitudeController,
                decoration: InputDecoration(
                  labelText: 'Longitude',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
