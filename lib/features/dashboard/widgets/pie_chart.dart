import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardPieChart extends StatefulWidget {
  final List<double> values;
  final List<Color> colors;

  const DashboardPieChart({
    super.key,
    required this.values,
    required this.colors,
  });
  @override
  State<DashboardPieChart> createState() => _DashboardPieChartState();
}

class _DashboardPieChartState extends State<DashboardPieChart> {
  int touchedIndex = -1;
  List names = [
    "New",
    "Pending",
    "Completed",
    "Rejected",
  ];

  @override
  Widget build(BuildContext context) {
    double total = widget.values.fold(0, (sum, value) => sum + value);
    return AspectRatio(
      aspectRatio: 1.7,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 25,
                  sections: _buildSections(total),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 50.0,
              bottom: 50.0,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Indicator(
                      color: widget.colors[index],
                      text: names[index],
                      isSquare: false,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(total) {
    return List.generate(widget.values.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 12.0 : 10.0;
      final radius = isTouched ? 50.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        color: widget.colors[index],
        value: widget.values[index],
        title: '${((widget.values[index] / total) * 100).toStringAsFixed(2)} %',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 12,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }
}
