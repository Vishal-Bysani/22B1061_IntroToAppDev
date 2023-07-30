import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budget_app/entries.dart';

class Graph extends StatelessWidget {
  final List<Entry> expenses;
  final int total;
  Graph({required this.expenses,required this.total});

  Map<String, int> getExpenseDataByCategory() {
    Map<String, int> dataByCategory = {};

    for (Entry expense in this.expenses) {
      dataByCategory[expense.category] =
          (dataByCategory[expense.category] ?? 0) + expense.price;
    }

    return dataByCategory;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Graph of Expenses vs Category",
        style:TextStyle(
            fontSize: 30,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            color: Colors.white
        )),
        centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.blue[400]

      ),
      backgroundColor: Colors.lightBlue[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: total.toDouble(),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value, _) => const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Set the font size for the bottom titles
                ),
                getTitles: (value) {
                  int index = value.toInt();
                  if (index >= 0 && index < expenses.length) {
                    return expenses[index].category;
                  }
                  return '';
                },
                margin: 8,
              ),
              topTitles: SideTitles(
                showTitles: false, // Set this to false to hide topTitles
              ),
              leftTitles: SideTitles(showTitles: true,
                getTextStyles: (value, _) => const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Set the font size for the left titles
                ),
              reservedSize: 50.0),
              rightTitles: SideTitles(showTitles: false)
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true, // Set this to false to hide horizontal grid lines
              drawVerticalLine: false, // Set this to false to hide vertical grid lines
              horizontalInterval: total.toDouble(), // Set the interval for horizontal grid lines
            ),
            barGroups: getExpenseDataByCategory().entries
                .map(
                  (entry) => BarChartGroupData(
                x: expenses
                    .indexWhere((expense) => expense.category == entry.key)
                    .toInt(),
                barRods: [
                  BarChartRodData(
                    y: entry.value.toDouble(),
                    colors: [Colors.blue],
                  ),
                  BarChartRodData(
                    y: 0,
                    colors: [Colors.transparent],
                  ),
                  BarChartRodData(
                    y: 0,
                    colors: [Colors.transparent],
                  ),
                  BarChartRodData(
                    y: 0,
                    colors: [Colors.transparent],
                  ),
                ],
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}
