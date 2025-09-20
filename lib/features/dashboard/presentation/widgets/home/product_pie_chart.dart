import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/features/dashboard/data/models/product_sold_model.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/home/sold/sold_cubit.dart';
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
                    BlocBuilder<SoldCubit, SoldState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () => _getPieChartText("N/A"),
                          loading: () => Center(
                            child: Transform.scale(
                              scale: 0.5,
                              child: const CircularProgressIndicator(),
                            ),
                          ),
                          loadingFailed: (message) => _getPieChartText(message),
                          loaded: (List<ProductSoldModel> soldList) {
                            if (soldList.isNotEmpty) {
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: PieChart(
                                        PieChartData(
                                          pieTouchData: PieTouchData(
                                            touchCallback: (FlTouchEvent event,
                                                pieTouchResponse) {
                                              // Handle touch interaction here
                                            },
                                          ),
                                          borderData: FlBorderData(
                                            show: false,
                                          ),
                                          sectionsSpace: 0,
                                          centerSpaceRadius: 40,
                                          sections:
                                              _getPieChartSections(soldList),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _getPieChartIndicators(soldList),
                                  ),
                                ],
                              );
                            } else {
                              return _getPieChartText("No Data");
                            }
                          },
                        );
                      },
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

  Widget _getPieChartText(String message) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 54,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections(
      List<ProductSoldModel> soldList) {
    return List.generate(soldList.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 24.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        color: CommonStyles.pieChartColors[i],
        value: soldList[i].totalQuantity.toDouble(),
        title: soldList[i].totalQuantity.toString(),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSecondary,
          shadows: shadows,
        ),
      );
    });
  }

  Widget _getPieChartIndicators(List<ProductSoldModel> soldList) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < soldList.length; i++) ...[
          Indicator(
            color: CommonStyles.pieChartColors[i],
            text: soldList[i].productName,
            isSquare: true,
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ],
    );
  }

}
