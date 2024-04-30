import 'package:flutter/material.dart';
import 'dart:ui'show FontFeature;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insuranceapp/screens/login_screen.dart';
import 'package:insuranceapp/screens/user_registration.dart';
 
final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue.shade900,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);
 
void main() {
  runApp(
    const App()
  );
}
 
class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
} 