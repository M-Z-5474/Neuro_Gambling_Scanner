import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PersonalAssessmentScreen extends StatefulWidget {
  @override
  _PersonalAssessmentScreenState createState() => _PersonalAssessmentScreenState();
}

class _PersonalAssessmentScreenState extends State<PersonalAssessmentScreen> {
  int _questionIndex = 0;
  int _totalScore = 0;

  final List<Map<String, Object>> _questions = [
    {
      'question': 'How often do you gamble?',
      'answers': {'Never': 0, 'Occasionally': 1, 'Frequently': 2, 'Always': 3}
    },
    {
      'question': 'Do you feel the need to hide gambling?',
      'answers': {'No': 0, 'Sometimes': 1, 'Yes': 2}
    },
    {
      'question': 'I find it hard to resist gambling urges.',
      'answers': {
        'Strongly Disagree': 0,
        'Disagree': 1,
        'Neutral': 2,
        'Agree': 3,
        'Strongly Agree': 4
      }
    },
    {
      'question': 'Do you chase losses when you lose money gambling?',
      'answers': {'Never': 0, 'Sometimes': 2, 'Always': 4}
    },
    {
      'question': 'Gambling affects my daily responsibilities.',
      'answers': {
        'Strongly Disagree': 0,
        'Disagree': 1,
        'Neutral': 2,
        'Agree': 3,
        'Strongly Agree': 4
      }
    },
    {
      'question': 'I gamble more than I can afford to lose.',
      'answers': {'Never': 0, 'Sometimes': 2, 'Often': 3, 'Always': 4}
    },
    {
      'question': 'Do you feel guilty after gambling?',
      'answers': {'No': 0, 'Sometimes': 1, 'Yes': 2}
    },
    {
      'question': 'Have you tried to stop gambling but couldn’t?',
      'answers': {'No': 0, 'Tried Once': 1, 'Multiple Times': 2}
    },
    {
      'question': 'I gamble when I feel stressed or bored.',
      'answers': {
        'Never': 0,
        'Rarely': 1,
        'Sometimes': 2,
        'Often': 3,
        'Always': 4
      }
    },
    {
      'question': 'I borrow money to gamble or pay gambling debts.',
      'answers': {'Never': 0, 'Sometimes': 2, 'Frequently': 4}
    },
  ];

  void _answerQuestion(int score) {
    setState(() {
      _totalScore += score;
      _questionIndex++;
    });
  }

  void _restartQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  String _getRiskLevel(int score) {
    if (score >= 20) return "High Risk";
    if (score >= 10) return "Medium Risk";
    return "Low Risk";
  }

  List<String> _getRecommendations(String riskLevel) {
    switch (riskLevel) {
      case 'High Risk':
        return [
          "Seek professional counseling or support groups.",
          "Use self-exclusion programs on gambling platforms.",
          "Inform a trusted person about your gambling behavior.",
          "Avoid high-risk environments like casinos or betting apps.",
        ];
      case 'Medium Risk':
        return [
          "Track your gambling behavior and set limits.",
          "Practice stress-reducing alternatives like exercise or hobbies.",
          "Talk to someone you trust about your habits.",
        ];
      default:
        return [
          "Keep monitoring your behavior regularly.",
          "Educate yourself about the risks of gambling addiction.",
        ];
    }
  }

  List<PieChartSectionData> _generatePieData() {
    return [
      PieChartSectionData(
        value: _totalScore.toDouble(),
        color: Colors.redAccent,
        title: 'Score',
        radius: 60,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        value: (40 - _totalScore).toDouble(), // Assuming max score is 40
        color: Colors.grey[300],
        title: '',
        radius: 50,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personal Assessment")),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: _questionIndex < _questions.length
            ? Padding(
          key: ValueKey<int>(_questionIndex),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _questions[_questionIndex]['question'] as String,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ...(_questions[_questionIndex]['answers'] as Map<String, int>).entries.map((entry) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                    onPressed: () => _answerQuestion(entry.value),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(entry.key, style: TextStyle(fontSize: 16)),
                  ),
                );
              }).toList(),
            ],
          ),
        )
            : Padding(
          key: ValueKey<int>(_questionIndex),
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Your Risk Level: ${_getRiskLevel(_totalScore)}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: PieChart(PieChartData(
                    sections: _generatePieData(),
                    centerSpaceRadius: 40,
                    sectionsSpace: 4,
                  )),
                ),
                SizedBox(height: 20),
                if (_getRiskLevel(_totalScore) != "Low Risk") ...[
                  Text(
                    "⚠️ You may be at risk of problematic gambling behavior.",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  SizedBox(height: 20),
                ] else ...[
                  Text(
                    "✅ You're doing well. Keep your habits healthy!",
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Tip: Stay aware of your behavior and set clear boundaries.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recommended Actions:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ..._getRecommendations(_getRiskLevel(_totalScore)).map((rec) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_right, size: 24, color: Colors.teal),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              rec,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _restartQuiz,
                  child: Text("Retake Assessment"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
