import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CompletedPage extends StatelessWidget {
  final int score;
  final int totalQuestion;
  const CompletedPage({super.key,required this.score , required this.totalQuestion});



  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover )
            ),
          ),

          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          Center(
            child: Padding(padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text('Congratulations',
                style: TextStyle(
                  fontSize: screensize.width*0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
                
                SizedBox(height: 20,),

                Text('You have completed the Quiz.',
                style: TextStyle(
                  fontSize: screensize.width*0.06,
                  color: Colors.white70,
                ),),

                SizedBox(height: 20,),

                Text('Your Score',
                style: TextStyle(
                  fontSize: screensize.width*0.07,
                  color: Colors.white,
                ),
                ),

                Text('$score/$totalQuestion',
                style: TextStyle(
                  fontSize: screensize.width*0.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,

                ),),

                const SizedBox(height: 30,),

                ElevatedButton.icon(onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, '/',(route)=>false);
                }, 
                icon:const  Icon(Icons.refresh),
                label:Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 221, 206, 224),
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                    elevation: 5
                  ),
                ),
              ],
            ),





              
            ),),
        ],
        
          )
        
      );
    
  }
}