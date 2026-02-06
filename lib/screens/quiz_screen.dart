import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../data/quiz_data.dart';
import '../models/question.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Question> _questions = QuizData.alGkQuestions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timeLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _handleAnswer(-1); // Time out
        }
      });
    });
  }

  void _handleAnswer(int index) {
    if (_isAnswered) return;
    
    _timer?.cancel();
    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;
      if (index == _questions[_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
    });

    // Wait for 1.5 seconds before moving to next question
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
      });
      _startTimer();
    } else {
      _showInterstitialAdAndNavigate();
    }
  }

  void _showInterstitialAdAndNavigate() {
    // Simulate Interstitial Ad
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Loading Interstitial Ad...'),
              ],
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context); // Close dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              score: _score,
              totalQuestions: _questions.length,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    double progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1A237E),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                   LinearPercentIndicator(
                    lineHeight: 8.0,
                    percent: progress,
                    backgroundColor: Colors.grey.shade300,
                    progressColor: const Color(0xFF1A237E),
                    barRadius: const Radius.circular(10),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.redAccent, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            '$_timeLeft s',
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Text(
                        question.questionText,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A237E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ...List.generate(
                      question.options.length,
                      (index) => _buildOption(index, question),
                    ),
                  ],
                ),
              ),
            ),
            _buildAdPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int index, Question question) {
    Color cardColor = Colors.white;
    Color textColor = Colors.black87;
    IconData? icon;

    if (_isAnswered) {
      if (index == question.correctAnswerIndex) {
        cardColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        icon = Icons.check_circle;
      } else if (index == _selectedAnswerIndex) {
        cardColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        icon = Icons.cancel;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => _handleAnswer(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: _selectedAnswerIndex == index 
                  ? const Color(0xFF1A237E) 
                  : Colors.grey.shade200,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  question.options[index],
                  style: TextStyle(
                    color: textColor,
                    fontWeight: _selectedAnswerIndex == index ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (icon != null) Icon(icon, color: textColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdPlaceholder() {
    return Container(
      width: double.infinity,
      height: 60,
      color: Colors.grey.shade200,
      child: const Center(
        child: Text(
          'Banner Ad Placeholder',
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ),
    );
  }
}
