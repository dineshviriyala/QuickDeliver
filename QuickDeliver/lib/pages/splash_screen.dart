import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'onBoardScreen.dart'; // Import your OnBoardScreen file

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _bikeOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _bikeOffset = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => onBoardScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            'assets/1.png',
            fit: BoxFit.fill,
            width: double.infinity,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            height: 300,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double progress = _controller.value;
                double shakeAmplitude =
                    0.01; // smaller shake angle (in radians)

                // Apply shake only for first 80% of animation, then stop suddenly
                double angle = 0;
                if (progress < 0.8) {
                  // Oscillate with decaying amplitude
                  angle = shakeAmplitude *
                      (1 - progress / 0.8) *
                      sin(progress * 10 * pi);
                } else {
                  angle = 0; // stop shaking suddenly near end
                }

                return SlideTransition(
                  position: _bikeOffset,
                  child: Transform.rotate(
                    angle: angle,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/3.png',
                //fit: BoxFit.fill,
                width: double.infinity,
                //width: 500,
              ),
            ),
          ),
          //10.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
            child: const Text(
              'QuickDeliver',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontFamily: 'LateFont',
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
