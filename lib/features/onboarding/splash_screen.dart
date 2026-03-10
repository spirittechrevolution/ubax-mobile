import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF21364A),
      body: SafeArea(
        child: Center(
          child: Image(
            image: AssetImage('assets/icons/logoUbaxWhite.png'),
            width: 110,
            height: 110,
          ),
        ),
      ),
    );
  }
}
