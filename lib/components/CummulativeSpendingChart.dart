import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/models/Category.dart';
import 'package:flutter_finance_app/models/UserTransaction.dart';

class _LineChart extends StatelessWidget {
  final List<dynamic> timeSeries;

  const _LineChart({required this.timeSeries});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData2(timeSeries),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData sampleData2(List<dynamic> timeSeries) => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsDataCummulative(timeSeries),
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipMargin: -40.0,
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (value) {
            List<LineTooltipItem> output = value
                .map((e) => LineTooltipItem(
                    "${Category.categoryOrder[e.barIndex]} => ${e.y.toStringAsFixed(2)} \n",
                    TextStyle(fontSize: 14, color: e.bar.colors[0])))
                .toList();
            return output;
          },
        ),
      );

  List<LineChartBarData>? lineBarsDataCummulative(List<dynamic> timeSeries) {
    List<LineChartBarData> lineChartBarDataList = [];

    for (var i = 0; i < timeSeries.length; i = i + 1) {
      lineChartBarDataList.add(lineChartBarDataCummulative(i, timeSeries[i]));
    }

    return lineChartBarDataList;
  }

  FlTitlesData get titlesData => FlTitlesData(
      bottomTitles: bottomTitles,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      leftTitles: SideTitles(showTitles: true));

  SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 8,
        reservedSize: 40,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 22,
        margin: 10,
        rotateAngle: 90,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        getTitles: (value) {
          DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(value.toInt());

          String title = "";

          switch (dateTime.month) {
            case 1:
              title = title + 'JAN';
              break;
            case 2:
              title = title + 'FEB';
              break;
            case 3:
              title = title + 'MAR';
              break;
            case 4:
              title = title + 'APR';
              break;
            case 5:
              title = title + 'MAY';
              break;
            case 6:
              title = title + 'JUN';
              break;
            case 7:
              title = title + 'JUL';
              break;
            case 8:
              title = title + 'AUG';
              break;
            case 9:
              title = title + 'SEPT';
              break;
            case 10:
              title = title + 'OCT';
              break;
            case 11:
              title = title + 'NOV';
              break;
            case 12:
              title = title + 'DEC';
          }

          return title + "/" + dateTime.year.toString();
        },
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData lineChartBarDataCummulative(
      int index, List<UserTransaction> userTransactionList) {
    List<FlSpot> flSpots = [];
    double sum = 0;
    for (var userTransaction in userTransactionList) {
      flSpots.add(FlSpot(userTransaction.date.millisecondsSinceEpoch.toDouble(),
          userTransaction.amount + sum));

      sum = sum + userTransaction.amount;
    }

    Color color = Category
            .categoryDictionary[Category.categoryOrder[index]]![Category.color]
        as Color;

    return LineChartBarData(
      colors: [color],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: flSpots,
    );
  }
}

class CummulativeSpendingChart extends StatefulWidget {
  final List<List<UserTransaction>> timeSeries;

  const CummulativeSpendingChart({required this.timeSeries, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CummulativeSpendingChartState();
}

class CummulativeSpendingChartState extends State<CummulativeSpendingChart> {
  bool cummulative = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            color: Colors.white),
        child: Stack(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20, left: 10.0, bottom: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      (this.cummulative == false
                          ? 'Cummulative spending'
                          : 'Spending through time'),
                      style: TextStyle(
                        color: Color(0xff827daa),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 37,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                        child: _LineChart(timeSeries: this.widget.timeSeries),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
