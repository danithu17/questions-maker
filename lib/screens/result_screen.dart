import 'package:flutter/material.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (score / totalQuestions) * 100;
    bool isPassed = percentage >= 50;

    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: Stack(
        children: [
          _buildBackgroundPatterns(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildScoreIcon(isPassed),
                  const SizedBox(height: 32),
                  Text(
                    isPassed ? 'Congratulations!' : 'Keep Practicing!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPassed 
                        ? 'Masterfully done! You are ready for the exam.' 
                        : 'Almost there! A bit more study will do it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                  ),
                  const SizedBox(height: 48),
                  _buildResultsCard(context, percentage),
                  const SizedBox(height: 48),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPatterns() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.1,
        child: Column(
          children: List.generate(10, (idx) => 
            Expanded(child: Row(
              children: List.generate(5, (idy) => 
                const Expanded(child: Icon(Icons.school_outlined, color: Colors.white, size: 40))
              ),
            ))
          ),
        ),
      ),
    );
  }

  Widget _buildScoreIcon(bool isPassed) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isPassed ? Icons.emoji_events_rounded : Icons.psychology_rounded,
        size: 80,
        color: isPassed ? Colors.amber : Colors.blue.shade200,
      ),
    );
  }

  Widget _buildResultsCard(BuildContext context, double percentage) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Your Score',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$score',
                style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
              Text(
                '/$totalQuestions',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF3949AB)]),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${percentage.toStringAsFixed(0)}% Accuracy',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1A237E),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: const Text('Try Another Exam', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.share_rounded, color: Colors.white70),
          label: const Text('Share Result', style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }
}
