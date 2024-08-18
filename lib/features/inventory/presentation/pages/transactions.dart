import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_model.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_product_model.dart';
import 'package:route_nxt/features/inventory/presentation/bloc/transaction/transaction_cubit.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final ScrollController _scrollController = ScrollController();
  final DateFormat formatter = DateFormat('yyyy-MM-dd H:mm');
  late TransactionCubit _transactionCubit;

  @override
  void initState() {
    super.initState();
    _transactionCubit = context.read<TransactionCubit>();
    _transactionCubit.refreshTransactions();
    _transactionCubit.fetchTransactions();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      _transactionCubit.state.maybeWhen(
        loaded: (transactionList, hasMore) {
          if (hasMore) {
            _transactionCubit.fetchTransactions();
          }
        },
        orElse: () {},
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
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
      return "0.00";
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
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
                GoRouter.of(context).pop();
              },
            ),
            title: Text(
              "Transactions".toUpperCase(),
              style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 1.2,
                  wordSpacing: 4,
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
          ),
          body: _productList(context),
        ));
  }

  _productList(BuildContext context) {
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
                    Icons.payments_rounded,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              const Text("Your Transactions",
                  style:
                      TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, state) {
              return state.when(
                  initial: () =>
                      const Center(child: CircularProgressIndicator()),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded:
                      (List<TransactionModel> transactionList, bool hasMore) {
                    return ListView.builder(
                      itemCount: transactionList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < transactionList.length) {
                          return _transactionCard(
                              context, transactionList[index]);
                        } else {
                          // Show loader at the bottom when fetching more items
                          return hasMore
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : const SizedBox
                                  .shrink(); // Don't show loader if no more items
                        }
                      },
                      controller: _scrollController,
                    );
                  },
                  loadingFailed: (message) => Center(child: Text(message)));
            },
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  _transactionCard(BuildContext context, TransactionModel model) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerLowest
                .withOpacity(0.2),
            width: 1),
        color: Theme.of(context).colorScheme.onTertiary,
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
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.fileInvoice,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
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
                      SizedBox(
                        child: Row(
                          children: [
                            const Text("Transaction ID: ",
                                style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600)),
                            Flexible(
                              child: Text(
                                model.id,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                          formatter.format(
                              DateTime.parse(model.createdDate.toString())),
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
                              color: CommonStyles.warningDarkColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                width: 1,
                                color: CommonStyles.warningDarkColor
                                    .withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                                "Total: ${_formatCurrency(model.total)}",
                                style: const TextStyle(
                                    color: CommonStyles.warningDarkColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
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
                ...model.productList
                    .map((product) => _buildProductCard(product)),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(TransactionProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      style: CommonStyles.summaryCardDataTitleStyles.copyWith(),
                    ),
                    Text(
                      product.name,
                      style: CommonStyles.summaryCardDataStyles.copyWith(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity',
                      style: CommonStyles.summaryCardDataTitleStyles.copyWith(),
                    ),
                    Text(
                      product.quantity.toString(),
                      style: CommonStyles.summaryCardDataStyles.copyWith(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                      'Total',
                      style: CommonStyles.summaryCardDataTitleStyles.copyWith(),
                    ),
                    Text(
                      _formatCurrency(product.total),
                      style: CommonStyles.summaryCardDataStyles.copyWith(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discount',
                      style: CommonStyles.summaryCardDataTitleStyles.copyWith(),
                    ),
                    Text(
                      "${_formatCurrency(product.discount)} %",
                      style: CommonStyles.summaryCardDataStyles.copyWith(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
