import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_application/complete_page.dart';
import 'package:quiz_application/features/option.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List responsiveData=[];
  int number=0;
  Timer?_timer;
  int secondsRemaining= 15;
  List<String> shuffledOptions =[];
  String?selectedOption;
  int score= 0;

    
    
  
  Future<void>api() async{
    final response = await http.get(Uri.parse('https://opentb.com/api.php?amount=10'));

    if(response.statusCode == 200){
      var data = jsonDecode(response.body)['results'];

      setState(() {
        responsiveData = data;
      
        if(responsiveData.isNotEmpty){
          updateShuffleOptions();
        }
      });


    }
  }

  @override
  void initState(){
    super.initState();
    api();
    startTimer();
  }

  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }

  void nextQuestion()
  {
    if(selectedOption == responsiveData[number]['correct_answer']){
      score++;
    }
    
  
  if(number < responsiveData.length -1){
    setState(() {
      number++;
      updateShuffleOptions();
      selectedOption = null;
      secondsRemaining =15;

    });
  }

  else{
    completed();
  }

  }

  void completed()
  {
    Navigator.pushReplacement(context,
    MaterialPageRoute(builder:
     (context)=> CompletedPage(
      score: score,
      totalQuestion: responsiveData.length,
     ),
     ),
     );
  }

void updateShuffleOptions(){
  var currenQuestion = responsiveData[number];
  List<String>options = List <String>.from(currenQuestion['incorrect_answer']);
  options.add(currenQuestion['correct_answer']);
  options.shuffle();

  setState(() {
    shuffledOptions=options;
  });
}

void startTimer(){
  _timer = Timer.periodic(const Duration(seconds: 1), (timer){
    setState(() {
      if(secondsRemaining>0){
        secondsRemaining--;
      }

      else{
        nextQuestion(){
          secondsRemaining =15;
        }
      }
    });
  });
}



  @override

  Widget build(BuildContext context) {
  var screensize = MediaQuery.of(context).size;

    return  Scaffold(
    
      body: Padding(padding:const EdgeInsets.all(20),
      child: Column(
        
        children: [
          SizedBox(
            height: screensize.height*0.5,
            width: screensize.height*0.9,
            child: Stack(
              children: [
                Container(
                  
                  height: screensize.height*0.4,
                  width: screensize.width*0.85,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 86, 78, 110),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 5,
                        spreadRadius: 2,
                        color: Color.fromARGB(255, 86, 78, 110).withOpacity(0.4),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 60,
                  left: 22,
                  child: Container(
                  height: screensize.height*0.3,
                  width: screensize.width*0.85,
                  decoration:BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        offset:const Offset(0, 1),
                        blurRadius: 5,
                        spreadRadius: 3,
                        color: const Color.fromARGB(255, 86, 78, 110).withOpacity(0.4),
                      ),
                    ]
                  ),

                  child: Padding(padding:const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      Center(child: Text("Questions ${number +1}/10",
                      style:const TextStyle(color: Color.fromARGB(0, 183, 187, 246)),
                      
                      ),),

                      const SizedBox(height: 20,),

                      Text(
                        responsiveData.isNotEmpty?
                        responsiveData[number]['question']:
                        'Loading......',
                        style: TextStyle(
                          fontSize: screensize.width*0.4
                        ),


                      ),
                    ],
                  ),
                  ),

                  

                  ),

                  //child: Padding(padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),),

                  
                ),

                Positioned(child: Icon(Icons.quiz,
                size: screensize.width*0.1,
                color: Colors.green,),
              ),

                Positioned(child: Icon(Icons.quiz,
                size: screensize.width*0.1,
                color: Colors.red,),
              ),

              Positioned(
                bottom: screensize.height*0.35,
                left: screensize.width*0.4,
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.amber,
                  child: Center(
                    child: Text(
                      secondsRemaining.toString(),
                      style: TextStyle(
                        color: const  Color.fromARGB(255, 86, 78, 110),
                        fontSize: screensize.width*0.06,
                      ),
                    ),
                  ),
                ),
              ),
              ],

            ),
          ),

          const SizedBox(height: 20,),

          Expanded(
              child: ListView.builder(
                itemCount: responsiveData.isNotEmpty && responsiveData[number]['incorrect_answers'] != null
                    ? shuffledOptions.length
                    : 0,
                itemBuilder: (context, index) {
                  String option = shuffledOptions[index];
                  return Options(
                    option: option,
                    onSelected: (String value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                    isSelected: selectedOption == option,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffA42FC1),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                onPressed: nextQuestion,
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      ),

    );
  }
}