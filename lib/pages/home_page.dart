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
  List responsiveData = [];
  int number = 0;
  Timer? _timer;
  int secondsRemaining = 15;
  List<String> shuffledOptions = [];
  String? selectedOption;
  int score = 0;

  Future<void> api() async {
    final response = await http.get(Uri.parse('https://opentdb.com/api.php?amount=10'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['results'];


      setState(() {
        responsiveData = data;
        if (responsiveData.isNotEmpty) {
          updateShuffleOptions();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    api();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void nextQuestion() {
    if (selectedOption == responsiveData[number]['correct_answer']) {
      score++;
    }

    if (number < responsiveData.length - 1) {
      setState(() {
        number++;
        updateShuffleOptions();
        selectedOption = null; // Reset the selected option
        secondsRemaining = 15;
      });
    } else {
      completed();
    }
  }

  void completed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CompletedPage(
          score: score,
          totalQuestion: responsiveData.length,
        ),
      ),
    );
  }

  void updateShuffleOptions() {
    var currentQuestion = responsiveData[number];
    List<String> options = List<String>.from(currentQuestion['incorrect_answers']);
    options.add(currentQuestion['correct_answer']);
    options.shuffle();

    setState(() {
      shuffledOptions = options;
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          nextQuestion();
          secondsRemaining = 15;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: screenSize.height * 0.5,  // Increased height
              width: screenSize.width * 0.9,
              child: Stack(
                children: [
                  Container(
                    height: screenSize.height * 0.4,  // Increased height
                    width: screenSize.width * 0.85,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(256, 86, 75, 110),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: 2,
                          color: Color.fromARGB(255,86,75,110)
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 22,
                    child: Container(
                      height: screenSize.height * 0.3,  // Increased height
                      width: screenSize.width * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 5,
                            spreadRadius: 3,
                            color: const Color.fromARGB(255, 86, 75, 110).withOpacity(0.4),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Question ${number + 1}/10",
                                style: const TextStyle(color: Color.fromARGB(255, 86, 75, 110)),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              responsiveData.isNotEmpty
                                  ? responsiveData[number]['question']
                                  : 'Loading...',
                              style: TextStyle(fontSize: screenSize.width * 0.04),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Icon(
                      Icons.quiz,
                      size: screenSize.width * 0.1,
                      color: Colors.green,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Icon(
                      Icons.quiz,
                      size: screenSize.width * 0.1,
                      color: Colors.red,
                    ),
                  ),
                  Positioned(
                    bottom: screenSize.height * 0.35,  // Adjusted position
                    left: screenSize.width * 0.4,
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.amber,
                      child: Center(
                        child: Text(
                          secondsRemaining.toString(),
                          style: TextStyle(
                            color: const Color.fromARGB(255, 86, 75, 110),
                            fontSize: screenSize.width * 0.06,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                  backgroundColor: const Color.fromARGB(255, 86, 75, 110),
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