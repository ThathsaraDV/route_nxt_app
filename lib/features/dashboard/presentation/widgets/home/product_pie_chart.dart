import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/features/dashboard/presentation/widgets/home/indicator.dart';

class ProductPieChart extends StatefulWidget {
  const ProductPieChart({super.key});

  @override
  State<ProductPieChart> createState() => _ProductPieChartState();
}

class _ProductPieChartState extends State<ProductPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        height: data.size.height * 0.45,
        padding: const EdgeInsets.only(left: 4, top: 4, right: 12, bottom: 0),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Products',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            textAlign: TextAlign.left),
                        const Text('Most Sales',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left),
                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
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
                                centerSpaceRadius: 40,
                                sections: showingSections(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Indicator(
                                color: CommonStyles.pieChartColors[0],
                                text: 'First',
                                isSquare: true,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: CommonStyles.pieChartColors[1],
                                text: 'Second',
                                isSquare: true,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: CommonStyles.pieChartColors[2],
                                text: 'Third',
                                isSquare: true,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: CommonStyles.pieChartColors[3],
                                text: 'Fourth',
                                isSquare: true,
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: CommonStyles.pieChartColors[i],
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondary,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: CommonStyles.pieChartColors[i],
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondary,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: CommonStyles.pieChartColors[i],
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondary,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: CommonStyles.pieChartColors[i],
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondary,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
