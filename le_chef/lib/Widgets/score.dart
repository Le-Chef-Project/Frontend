import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class QuizScoreCard extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final int unanswered;
  final int totalQuestions;

  const QuizScoreCard({
    Key? key,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.unanswered,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure the values are always included, even if they are zero
    final chartSections = [
      PieChartSectionData(
        value: correctAnswers.toDouble(),
        color: Colors.green,
        title: correctAnswers > 0 ? correctAnswers.toString() : '0',
        titleStyle: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: wrongAnswers.toDouble(),
        color: Colors.red,
        title: wrongAnswers > 0 ? wrongAnswers.toString() : '0',
        titleStyle: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: unanswered.toDouble(),
        color: Colors.orange,
        title: unanswered > 0 ? unanswered.toString() : '0',
        titleStyle: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Card(
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Pie Chart and Score Section with Divider
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 150,
                      child: PieChart(
                        PieChartData(
                          sections: chartSections,
                          sectionsSpace: 4,
                          centerSpaceRadius: 0,
                        ),
                      ),
                    ),
                  ),
                  // Vertical Divider with a defined height
                  SizedBox(
                    height: 100, // Set height for the divider to display
                    child: const VerticalDivider(
                      color: Color(0xFF888888),
                      thickness: 1,
                      width: 20,
                    ),
                  ),
                  // Score Display Section
                  Column(
                    children: [
                      Text(
                        'Total Score',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${correctAnswers}/${totalQuestions}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0E7490)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Additional horizontal divider before the Legend Section
              SizedBox(
                width: 200,
                child: const Divider(
                  color: Color(0xFF888888),
                  thickness: 1,
                ),
              ),
              const SizedBox(height: 2),

              // Legend Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendIndicator(Colors.green, 'Correct Answers'),
                  const SizedBox(width: 8),
                  _buildLegendIndicator(Colors.orange, 'Not Answered'),
                  const SizedBox(width: 8),
                  _buildLegendIndicator(Colors.red, 'Wrong Answers'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Legend Indicator Widget
  Widget _buildLegendIndicator(Color color, String text) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }
}
