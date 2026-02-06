import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  late List<Question> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;

  // Ads
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    // Shuffle questions
    _questions = List.from(QuizData.alGkQuestions)..shuffle();
    _startTimer();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7036399347927896/7504313122', // Real Banner ID from User
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() => _isBannerLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('BannerAd failed to load: $error');
        },
      ),
    )..load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test Interstitial ID (replace with real one when available)
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _startTimer() {
    _timeLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        _timer?.cancel();
        return;
      }
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _handleAnswer(-1);
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

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _nextQuestion();
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
      _showAdAndNavigate();
    }
  }

  void _showAdAndNavigate() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _navigateToResults();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _navigateToResults();
        },
      );
      _interstitialAd!.show();
    } else {
      _navigateToResults();
    }
  }

  void _navigateToResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(score: _score, totalQuestions: _questions.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    final question = _questions[_currentQuestionIndex];
    double progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text('Performance Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A237E),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(progress),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  children: [
                    _buildTimerSection(),
                    const SizedBox(height: 24),
                    _buildQuestionCard(question),
                    const SizedBox(height: 32),
                    ...List.generate(
                      question.options.length,
                      (index) => _buildOptionCard(index, question),
                    ),
                  ],
                ),
              ),
            ),
            if (_isBannerLoaded)
              Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              )
            else
              _buildAdPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        children: [
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: progress,
            backgroundColor: Colors.grey.shade100,
            progressColor: const Color(0xFF1A237E),
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const Text('Active Quiz', style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _timeLeft < 10 ? Colors.red.withValues(alpha: 0.1) : const Color(0xFF1A237E).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 18, color: _timeLeft < 10 ? Colors.red : const Color(0xFF1A237E)),
          const SizedBox(width: 8),
          Text(
            '$_timeLeft Seconds Left',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _timeLeft < 10 ? Colors.red : const Color(0xFF1A237E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        question.questionText,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.5, color: Color(0xFF1A237E)),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionCard(int index, Question question) {
    bool isSelected = _selectedAnswerIndex == index;
    bool isCorrect = index == question.correctAnswerIndex;
    
    Color borderColor = Colors.grey.shade200;
    Color bgColor = Colors.white;
    Color textColor = Colors.black87;
    IconData? icon;

    if (_isAnswered) {
      if (isCorrect) {
        borderColor = Colors.green.shade400;
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade900;
        icon = Icons.check_circle_rounded;
      } else if (isSelected) {
        borderColor = Colors.red.shade400;
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade900;
        icon = Icons.cancel_rounded;
      }
    } else if (isSelected) {
      borderColor = const Color(0xFF1A237E);
      bgColor = const Color(0xFF1A237E).withValues(alpha: 0.05);
      textColor = const Color(0xFF1A237E);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _handleAnswer(index),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
                  color: isSelected ? (isCorrect && _isAnswered ? Colors.green : (isCorrect ? Colors.green : (_isAnswered ? Colors.red : const Color(0xFF1A237E)))) : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  question.options[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              if (icon != null) Icon(icon, color: textColor, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdPlaceholder() {
    return Container(
      height: 60,
      width: double.infinity,
      color: Colors.transparent,
    );
  }
}
