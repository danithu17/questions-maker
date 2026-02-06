import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../data/quiz_data.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int questionIndex = 0;
  int score = 0;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isBannerAdLoaded = true),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void answerQuestion(int scoreValue) {
    score += scoreValue;
    if (questionIndex < quizQuestions.length - 1) {
      setState(() {
        questionIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(score: score, totalQuestions: quizQuestions.length),
        ),
      );
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = quizQuestions[questionIndex];
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currentQuestion['question'] as String, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  ...(currentQuestion['answers'] as List<Map<String, dynamic>>).map((answer) {
                    return ElevatedButton(
                      onPressed: () => answerQuestion(answer['score'] as int),
                      child: Text(answer['text'] as String),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          if (_isBannerAdLoaded)
            SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}
