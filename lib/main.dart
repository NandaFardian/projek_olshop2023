import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:olshop2023/screen/auth/login.dart';

void main() {
  runApp(
    MaterialApp(
      home: AnimatedSplashScreen(
          splash: 'images/logo.png',
          splashTransition: SplashTransition.fadeTransition,
          duration: 2500,
          backgroundColor: const Color.fromARGB(255, 255, 228, 199),
          nextScreen: Login()),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
