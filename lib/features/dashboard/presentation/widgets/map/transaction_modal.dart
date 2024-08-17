import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/core/utility/service_locator.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_location_model.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_model.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_product_model.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_wrapper_body.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';
import 'package:route_nxt/features/dashboard/presentation/bloc/transaction/transaction_record_cubit.dart';
import 'package:route_nxt/features/inventory/data/models/product_model.dart';

class TransactionModal extends StatefulWidget {
  final List<ProductModel> productList;
  final LocationData currentLocation;

  const TransactionModal(
      {super.key, required this.productList, required this.currentLocation});

  @override
  State<TransactionModal> createState() => _TransactionModalState();
}

class _TransactionModalState extends State<TransactionModal> {
  final transactionFormKey = GlobalKey<FormState>();
  List<TransactionProductModel> selectedProductList = [
    TransactionProductModel(name: '', quantity: 0, total: 0.00, discount: 0.00)
  ];
  double fullTotal = 0.00;

  void addProductRow() {
    setState(() {
      selectedProductList.add(TransactionProductModel(
          name: '', quantity: 0, total: 0.00, discount: 0.00));
    });
  }

  void removeProductRow(int index) {
    reduceTotalSum(index);
    setState(() {
      selectedProductList.removeAt(index);
    });
  }

  void submitTransaction(BuildContext context) {
    if (transactionFormKey.currentState!.validate()) {
      context.read<TransactionRecordCubit>().saveTransaction(
          TransactionWrapperBody(
              TransactionModel(DateTime.now(), fullTotal, selectedProductList),
              TransactionLocationModel(
                  widget.currentLocation.latitude!.toString(),
                  widget.currentLocation.longitude!.toString(),
                  fullTotal)));
    }
  }

  void onProductChange(int index, ProductModel value) {
    setState(() {
      selectedProductList[index].productId = value.id!;
      selectedProductList[index].name = value.name!;
      selectedProductList[index].discount = value.discount!;
      selectedProductList[index].sellingPrice = value.selling!;
      selectedProductList[index].currentQty = value.quantity!;
    });
    updateTotalSum(index);
  }

  void onQtyChange(int index, String value) {
    reduceTotalSum(index);
    if (value.isNotEmpty) {
      setState(() {
        selectedProductList[index].quantity = int.parse(value);
      });
      updateTotalSum(index);
    } else {
      selectedProductList[index].quantity = 0;
      selectedProductList[index].total = 0.00;
    }
  }

  void reduceTotalSum(int index) {
    setState(() {
      fullTotal -= selectedProductList[index].total;
    });
  }

  void updateTotalSum(int index) {
    TransactionProductModel selected = selectedProductList[index];
    if (0.00 != selected.sellingPrice && 0 != selected.quantity) {
      double total = selected.quantity * selected.sellingPrice;
      if (selected.discount != 0.0) {
        total = (total / 100.00) * (100.00 - selected.discount);
      }
      selected.total = total;
      setState(() {
        fullTotal += total;
      });
    }
  }

  void resetModal() {
    setState(() {
      selectedProductList = [
        TransactionProductModel(
            name: '', quantity: 0, total: 0.00, discount: 0.00)
      ];
      fullTotal = 0.00;
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    final MediaQueryData data = MediaQuery.of(buildContext);
    double screenWidth = MediaQuery.of(buildContext).size.width;
    double screenHeight = MediaQuery.of(buildContext).size.height;
    double dialogPadding = screenWidth * 0.035;
    return MediaQuery(
      data: data.copyWith(textScaler: const TextScaler.linear(1.0)),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TransactionRecordCubit>.value(
            value: sl<TransactionRecordCubit>(),
          )
        ],
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocConsumer<TransactionRecordCubit, TransactionRecordState>(
            listener: (context, state) {
              state.maybeWhen(
                  saved: (TransactionWrapperBody transactionWrapperBody) {
                    resetModal();
                    CustomSnackBar.showSnackBar(
                        null, "Transaction Recorded Successfully", 'success');
                    GoRouter.of(context).pop();
                  },
                  savingFailed: (message) {
                    resetModal();
                    CustomSnackBar.showSnackBar(null, message, 'error');
                  },
                  orElse: () {});
            },
            builder: (context, state) {
              return state.when(
                  initial: () => _transactionDialog(
                      context, screenWidth, screenHeight, dialogPadding),
                  saving: () =>
                      const Center(child: CircularProgressIndicator()),
                  saved: (TransactionWrapperBody transactionWrapperBody) =>
                      _transactionDialog(
                          context, screenWidth, screenHeight, dialogPadding),
                  savingFailed: (message) => _transactionDialog(
                      context, screenWidth, screenHeight, dialogPadding));
            },
          ),
        ),
      ),
    );
  }

  Widget _transactionDialog(BuildContext context, double screenWidth,
      double screenHeight, double dialogPadding) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          width: screenWidth * 0.9,
          padding: EdgeInsets.all(dialogPadding),
          child: Form(
            key: transactionFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                'New Transaction',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    letterSpacing: 0.75,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              )),
                        ),
                        SizedBox(
                          width: 24,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const SizedBox(
                    child: Text(
                      "Select products and their respective quantities. Your current location will be saved along with the transaction.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        letterSpacing: 0.85,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Total Sum : ',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    letterSpacing: 0.75,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                fullTotal.toString(),
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    letterSpacing: 0.75,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: screenHeight * 0.5,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...selectedProductList.asMap().entries.map((entry) {
                            int index = entry.key;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: DropdownSearch<ProductModel>(
                                      validator: (ProductModel? value) {
                                        if (value == null) {
                                          return "Cannot be empty";
                                        }
                                        return null;
                                      },
                                      popupProps: const PopupProps.menu(
                                        fit: FlexFit.loose,
                                        showSelectedItems: true,
                                      ),
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(12),
                                          hintText: 'Select Product',
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.1),
                                          errorStyle:
                                              const TextStyle(fontSize: 9),
                                          enabledBorder: CommonStyles
                                              .buildSharedInputBorder(),
                                          focusedBorder: CommonStyles
                                              .buildFocusedInputBorder(),
                                          border: CommonStyles
                                              .buildSharedInputBorder(),
                                        ),
                                      ),
                                      compareFn: (i, s) => i == s,
                                      itemAsString: (ProductModel listItem) =>
                                          listItem.name!,
                                      items: widget.productList,
                                      onChanged: (value) =>
                                          onProductChange(index, value!),
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Cannot be empty.";
                                        }
                                        if (0 !=
                                                selectedProductList[index]
                                                    .currentQty &&
                                            int.parse(value) >
                                                selectedProductList[index]
                                                    .currentQty) {
                                          return "Insufficient stock.";
                                        }
                                        return null;
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                        LengthLimitingTextInputFormatter(10)
                                      ],
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.1),
                                        enabledBorder: CommonStyles
                                            .buildSharedInputBorder(),
                                        focusedBorder: CommonStyles
                                            .buildFocusedInputBorder(),
                                        border: CommonStyles
                                            .buildSharedInputBorder(),
                                        labelText: 'Quantity',
                                        errorStyle:
                                            const TextStyle(fontSize: 9),
                                      ),
                                      textCapitalization:
                                          TextCapitalization.words,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      onChanged: (value) =>
                                          onQtyChange(index, value),
                                    ),
                                  ),
                                  Visibility(
                                    visible: selectedProductList.length != 1,
                                    child: IconButton(
                                      icon: const Icon(Icons.remove_circle,
                                          color: Colors.red),
                                      onPressed: () => removeProductRow(index),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                          SizedBox(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: addProductRow,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    width: 1.25,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  fixedSize: const Size(180, 42),
                                ),
                                icon: Icon(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  Icons.add_rounded,
                                  size: 24,
                                ),
                                label: Text('Add Product'.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    )),
                              )
                            ],
                          )),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: CommonStyles.secondaryButtonStyles(
                              minimumSizeWidth: 100,
                              minimumSizeHeight: 42,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                          onPressed: () => submitTransaction(context),
                          child: Text('submit'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
