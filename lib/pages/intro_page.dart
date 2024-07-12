import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'balloon2.png',
            fit: BoxFit.fill,
          ),

          Container(
           decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.5)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            )
           ), 
          ),

           Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('QUIZZY',
              style: TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(5.0,5.0)
                  )
                ],
                fontSize: 50,
                fontWeight: FontWeight.bold,

              ),),

              const SizedBox(height: 20,),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/homepage');
              
              }, 
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 86, 78, 110),
                padding: EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                textStyle: TextStyle(
                  fontSize: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
              
              child: Text('Start Quiz'))
            ],
          )
        ],
      ),
    );
  }
}