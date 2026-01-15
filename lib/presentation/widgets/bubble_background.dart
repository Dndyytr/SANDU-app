import 'package:flutter/material.dart';

class BubbleBackground extends StatelessWidget {
  const BubbleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -50,
          left: -30,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Color(0xFF89E3D7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: 10,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Color(0xFF89E3D7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: -10,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF89E3D7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 280,
          left: 0,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF89E3D7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 340,
          left: 30,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Color(0xFF89E3D7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 370,
          left: 5,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: Color(0xFF89E3D7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 40,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF89E3D7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 10,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Color(0xFF89E3D7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 130,
          right: -20,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF89E3D7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 190,
          right: 10,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Color(0xFF89E3D7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 280,
          right: -50,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Color(0xFF89E3D7),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
