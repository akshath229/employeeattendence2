import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotest/const/Colours.dart';

import 'screen/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock the orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: AllColours.backgroundcolor,
          appBarTheme: const AppBarTheme(color: AllColours.backgroundcolor,)),
      home: const Homepage(),
    );
  }
}
