import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/home/distance/distance_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/home/sales/sales_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/home/sold/sold_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/home/stock/stock_cubit.dart';
import 'package:route_nxt/features/dashboard/presentation/widgets/home/product_pie_chart.dart';
import 'package:route_nxt/features/dashboard/presentation/widgets/home/sales_bar_chart.dart';
import 'package:route_nxt/features/inventory/data/models/product_model.dart';
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
  void initState() {
    super.initState();
    context.read<DistanceCubit>().getDistanceThisWeek();
    context.read<SalesCubit>().getNetTotalThisWeek();
    context.read<StockCubit>().getLowStockProducts();
    context.read<SoldCubit>().getProductsSoldThisWeek();
  }

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
      padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 3),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BlocBuilder<DistanceCubit, DistanceState>(
                builder: (context, state) {
                  return state.when(
                      initial: () => _getDistanceText("N/A"),
                      loading: () => Center(
                              child: Transform.scale(
                            scale: 0.5,
                            child: const CircularProgressIndicator(),
                          )),
                      loaded: (double distance) =>
                          _getDistanceText("${distance.toStringAsFixed(3)} km"),
                      loadingFailed: (message) => _getDistanceText(message));
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _getDistanceText(String distance) {
    return Text(distance,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis),
        textAlign: TextAlign.left);
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
      padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 2),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BlocBuilder<SalesCubit, SalesState>(
                builder: (context, state) {
                  return state.when(
                      initial: () => _getNetProfitText("N/A"),
                      loading: () => Center(
                              child: Transform.scale(
                            scale: 0.5,
                            child: const CircularProgressIndicator(),
                          )),
                      loaded:
                          (double netTotal, Map<String, double> barChartData) =>
                              _getNetProfitText(netTotal.toStringAsFixed(2)),
                      loadingFailed: (message) => _getNetProfitText(message));
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _getNetProfitText(String netProfit) {
    return Text(netProfit,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis),
        textAlign: TextAlign.left);
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
        mainAxisAlignment: MainAxisAlignment.start,
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
            height: data.size.height * 0.015,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BlocBuilder<StockCubit, StockState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => _getLowProductList([], "N/A"),
                    loading: () => Center(
                      child: Transform.scale(
                        scale: 0.8,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                    loaded: (List<ProductModel> productList) {
                      if (productList.isEmpty) {
                        return _getLowProductList([], "No Data");
                      } else {
                        return _getLowProductList(productList, "");
                      }
                    },
                    loadingFailed: (message) => _getLowProductList([], message),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _getLowProductList(List<ProductModel> productList, String message) {
    if (productList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: productList.map((product) {
          return Text(
            product.name ?? "N/A",
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis),
            textAlign: TextAlign.right,
          );
        }).toList(),
      );
    } else {
      return Text(message,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis),
          textAlign: TextAlign.left);
    }
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
