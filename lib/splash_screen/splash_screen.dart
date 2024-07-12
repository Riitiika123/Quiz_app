import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void initState(){
    super.initState();
    Timer(const Duration(seconds: 5),(){
      Navigator.of(context).pushReplacementNamed('/intro');
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 86, 78, 110)
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(
                Icons.quiz,
                size: 75,
                color: Colors.white,
                ),
                
                SizedBox(height: 30,),

                Text('QUIZZY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 40,
                ),)

                
                ],
            ),
          )
        ],
      ),
    );
  }
}