import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TasgrifCharts extends StatefulWidget {
  const TasgrifCharts({super.key});

  @override
  State<TasgrifCharts> createState() => _TasgrifChartsState();
}

class _TasgrifChartsState extends State<TasgrifCharts> {
  final List<String> months = ['Dec', 'Jan', 'Feb', 'Mar', 'Apr', 'May'];
  final List<BarChartGroupData> barGroups = [
    BarChartGroupData(x: 0, barRods: [
      BarChartRodData(toY: 0, color: Colors.blue),
      BarChartRodData(toY: 0, color: Colors.green),
      BarChartRodData(toY: 0, color: Colors.orange),
      BarChartRodData(toY: 0, color: Colors.pinkAccent),
    ]),
    BarChartGroupData(x: 1, barRods: [
      BarChartRodData(toY: 0, color: Colors.blue),
      BarChartRodData(toY: 0, color: Colors.green),
      BarChartRodData(toY: 0, color: Colors.orange),
      BarChartRodData(toY: 0, color: Colors.pinkAccent),
    ]),
    BarChartGroupData(x: 2, barRods: [
      BarChartRodData(toY: 0, color: Colors.blue),
      BarChartRodData(toY: 0, color: Colors.green),
      BarChartRodData(toY: 0, color: Colors.orange),
      BarChartRodData(toY: 0, color: Colors.pinkAccent),
    ]),
    BarChartGroupData(x: 3, barRods: [
      BarChartRodData(toY: 2002, color: Colors.blue),
      BarChartRodData(toY: 87, color: Colors.green),
      BarChartRodData(toY: 66, color: Colors.orange),
      BarChartRodData(toY: 0, color: Colors.pinkAccent),
    ]),
    BarChartGroupData(x: 4, barRods: [
      BarChartRodData(toY: 453, color: Colors.blue),
      BarChartRodData(toY: 100, color: Colors.green),
      BarChartRodData(toY: 80, color: Colors.orange),
      BarChartRodData(toY: 131, color: Colors.pinkAccent),
    ]),
    BarChartGroupData(x: 5, barRods: [
      BarChartRodData(toY: 9, color: Colors.blue),
      BarChartRodData(toY: 3, color: Colors.green),
      BarChartRodData(toY: 0, color: Colors.orange),
      BarChartRodData(toY: 113, color: Colors.pinkAccent),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        title: const Text("Tashriflar Statistikasi"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Oylar bo'yicha tashriflar statistikasi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < months.length) {
                            return Text(months[value.toInt()]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                  barGroups: barGroups,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String category = '';
                        switch (rodIndex) {
                          case 0:
                            category = 'Tashriflar';
                            break;
                          case 1:
                            category = 'Guruhga biriktirildi';
                            break;
                          case 2:
                            category = 'To\'lov qildi';
                            break;
                          case 3:
                            category = 'Aktiv talabalar';
                            break;
                        }
                        return BarTooltipItem(
                          '$category\n${rod.toY}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 10,
              children: const [
                _Legend(color: Colors.blue, text: 'Tashriflar'),
                _Legend(color: Colors.green, text: 'Guruhga biriktirildi'),
                _Legend(color: Colors.orange, text: 'To\'lov qildi'),
                _Legend(color: Colors.pinkAccent, text: 'Aktiv talabalar'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
