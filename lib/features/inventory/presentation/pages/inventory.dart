import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';
import 'package:route_nxt/features/inventory/data/models/product_model.dart';
import 'package:route_nxt/features/inventory/presentation/bloc/inventory/inventory_cubit.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd H:mm');
  List<ProductModel> productList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryCubit>().getAllProducts();
    });
  }

  String formatDate(DateTime? date) {
    if (null == date) {
      return "N/A";
    } else {
      return formatter.format(date);
    }
  }

  String _formatCurrency(double? value) {
    if (null != value) {
      var formatter = NumberFormat.currency(customPattern: '#,###.##');
      String amount = value.toString();
      if (!amount.contains('.')) {
        amount = "$amount.00";
      }
      amount = amount.replaceAll(',', '');
      String formattedAmount = formatter.format(double.parse(amount));
      return formattedAmount;
    } else {
      return "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    return BlocConsumer<InventoryCubit, InventoryState>(
      listener: (context, state) {
        state.maybeWhen(
            orElse: () {},
            loadingFailed: (message) {
              CustomSnackBar.showSnackBar(null, message, 'error');
            });
      },
      builder: (context, state) {
        return MediaQuery(
            data: data.copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Theme.of(context).colorScheme.primary,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  iconSize: 24,
                  onPressed: () {
                    GoRouter.of(context).pushReplacement('/home');
                  },
                ),
                title: Text(
                  "Inventory".toUpperCase(),
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 1.2,
                      wordSpacing: 4,
                      fontWeight: FontWeight.w700),
                ),
                centerTitle: true,
              ),
              body: state.when(
                  initial: () =>
                      const Center(child: CircularProgressIndicator()),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (List<ProductModel> productList) {
                    return _productList(context, productList);
                  },
                  loadingFailed: (message) {
                    return _productList(context, productList);
                  }),
            ));
      },
    );
  }

  _productList(BuildContext context, List<ProductModel> productList) {
    this.productList = productList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 6,
        ),
        Container(
          margin:
              const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.shelves,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              const Text("Your Inventory",
                  style:
                      TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(productList.length, (index) {
                return _productCard(context, index);
              }),
            ),
          ),
        ),
      ],
    );
  }

  _productCard(BuildContext context, int index) {
    ProductModel product = productList[index];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.scrim.withOpacity(0.2),
            width: 1),
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            spreadRadius: 4,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ], // Set the border radius
      ),
      child: ExpandableTheme(
        data: ExpandableThemeData(
          iconPadding:
              const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10),
          iconPlacement: ExpandablePanelIconPlacement.right,
          animationDuration: const Duration(milliseconds: 500),
          iconColor: Theme.of(context).colorScheme.primary,
        ),
        child: ExpandablePanel(
          header: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  child: Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.4),
                          width: 1.0,
                          style: BorderStyle.solid),
                    ),
                    child: Icon(
                      Icons.inventory_2_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(product.name ?? "N/A",
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      Text(formatDate(product.createdDate),
                          style: const TextStyle(
                              fontSize: 9.5, fontWeight: FontWeight.w500)),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 1.5, bottom: 1.5, left: 4, right: 4),
                            decoration: BoxDecoration(
                              color: product.status!
                                  ? CommonStyles.infoMsgBgColor.withOpacity(0.1)
                                  : CommonStyles.errorMsgBgColor
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                width: 1,
                                color: product.status!
                                    ? CommonStyles.infoMsgBgColor
                                        .withOpacity(0.2)
                                    : CommonStyles.errorMsgBgColor
                                        .withOpacity(0.2),
                              ),
                            ),
                            child: Text(product.status! ? "ACTIVE" : "INACTIVE",
                                style: TextStyle(
                                    color: product.status!
                                        ? CommonStyles.infoMsgBgColor
                                        : CommonStyles.errorMsgBgColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    GoRouter.of(context).go('/updateProduct', extra: product.id);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 2, bottom: 2),
                                    margin: const EdgeInsets.only(bottom: 2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color:
                                              CommonStyles.successMsgBgColor),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.refresh,
                                          size: 14,
                                          color: CommonStyles.successMsgBgColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Update",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                CommonStyles.successMsgBgColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          collapsed: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
          ),
          expanded: Container(
            padding:
                const EdgeInsets.only(top: 0, bottom: 12, left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  "Product Details",
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name',
                              style: CommonStyles.summaryCardDataTitleStyles
                                  .copyWith(),
                            ),
                            Text(
                              product.name ?? "N/A",
                              style:
                                  CommonStyles.summaryCardDataStyles.copyWith(),
                            ),
                          ],
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Code',
                              style: CommonStyles.summaryCardDataTitleStyles
                                  .copyWith(),
                            ),
                            Text(
                              product.code ?? "N/A",
                              style:
                                  CommonStyles.summaryCardDataStyles.copyWith(),
                            ),
                          ],
                        )),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buying Price',
                              style: CommonStyles.summaryCardDataTitleStyles
                                  .copyWith(),
                            ),
                            Text(
                              _formatCurrency(product.buying),
                              style:
                                  CommonStyles.summaryCardDataStyles.copyWith(),
                            ),
                          ],
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selling Price',
                              style: CommonStyles.summaryCardDataTitleStyles
                                  .copyWith(),
                            ),
                            Text(
                              _formatCurrency(product.selling),
                              style:
                                  CommonStyles.summaryCardDataStyles.copyWith(),
                            ),
                          ],
                        )),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantity',
                              style: CommonStyles.summaryCardDataTitleStyles
                                  .copyWith(),
                            ),
                            Text(
                              null != product.quantity
                                  ? product.quantity.toString()
                                  : "N/A",
                              style:
                                  CommonStyles.summaryCardDataStyles.copyWith(),
                            ),
                          ],
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Discount',
                              style: CommonStyles.summaryCardDataTitleStyles
                                  .copyWith(),
                            ),
                            Text(
                              null != product.discount
                                  ? "${_formatCurrency(product.discount)} %"
                                  : "N/A",
                              style:
                                  CommonStyles.summaryCardDataStyles.copyWith(),
                            ),
                          ],
                        )),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
