import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:route_nxt/features/dashboard/presentation/widgets/home/product_pie_chart.dart';
import 'package:route_nxt/features/dashboard/presentation/widgets/home/sales_bar_chart.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final _accountCardController = PageController();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          SizedBox(
            height: data.size.height * 0.015,
          ),
          _getDetailCards(context, data),
          SizedBox(
            height: data.size.height * 0.015,
          ),
          _getCharts(context, data)
        ],
      ),
    );
  }

  _getDetailCards(BuildContext context, MediaQueryData data) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      axisDirection: AxisDirection.down,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: _getDistanceCard(context),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: _getInventoryCard(context, data),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: _getProfitCard(context),
          ),
        ),
      ],
    );
  }

  _getDistanceCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            spreadRadius: 4,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: const Center(
                  child: Icon(
                    Icons.tour_rounded,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Distance',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.primaryContainer),
                        textAlign: TextAlign.left),
                    const Text('Weekly',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left),
                  ],
                ),
              )
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('12000',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left)
            ],
          ),
        ],
      ),
    );
  }

  _getProfitCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            spreadRadius: 4,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.16),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: const Center(
                  child: Icon(
                    Icons.attach_money,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Net Profit',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.primaryContainer),
                        textAlign: TextAlign.left),
                    const Text('Weekly',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left),
                  ],
                ),
              )
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('20000.00',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left)
            ],
          ),
        ],
      ),
    );
  }

  _getInventoryCard(BuildContext context, MediaQueryData data) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            spreadRadius: 4,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 8, top: 6, right: 10, bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: const Center(
                  child: Icon(
                    Icons.inventory_2_rounded,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Inventory',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.primaryContainer),
                        textAlign: TextAlign.left),
                    const Text('Low on stock',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: data.size.height * 0.01,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Product 1',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left),
                  Text('Product 2',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left),
                  Text('Product 3',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left)
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  _getCharts(BuildContext context, MediaQueryData data) {
    return SizedBox(
      child: SizedBox(
        height: data.size.height * 0.48,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .shadow
                            .withOpacity(0.1),
                        spreadRadius: 6,
                        blurRadius: 14,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 4, right: 4),
                  height: data.size.height * 0.45,
                  child: PageView(
                    controller: _accountCardController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (int index) {},
                    children: const [SalesBarChart(), ProductPieChart()],
                  )),
              Positioned(
                bottom: -10,
                child: SmoothPageIndicator(
                  controller: _accountCardController,
                  count: 2,
                  effect: WormEffect(
                      spacing: 8.0,
                      radius: 10,
                      dotWidth: 10,
                      dotHeight: 10,
                      activeDotColor:
                          Theme.of(context).colorScheme.primaryContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
