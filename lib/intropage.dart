import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Start animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward(); // Start animation

    // Navigate to Login Page after 5 seconds
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image from Assets
          Image.asset(
            "assets/intro_background.png", // Replace with your actual image asset
            fit: BoxFit.cover,
          ),

          // Centered Animated Text
          Center(
            child: FadeTransition(
              opacity: _animation, // Fade-in effect
              child: ScaleTransition(
                scale: _animation, // Scale-up effect
                child: Text(
                  "SEIVAR",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
