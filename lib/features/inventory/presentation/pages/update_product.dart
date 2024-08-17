import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:route_nxt/config/constants/common_styles.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';
import 'package:route_nxt/features/inventory/data/models/product_model.dart';
import 'package:route_nxt/features/inventory/presentation/bloc/update_product/update_product_cubit.dart';

class UpdateProduct extends StatefulWidget {
  final String productId;

  const UpdateProduct({super.key, required this.productId});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerBuying = TextEditingController();
  final TextEditingController controllerSelling = TextEditingController();
  final TextEditingController controllerQty = TextEditingController();
  final TextEditingController controllerDiscount = TextEditingController();
  final TextEditingController controllerCode = TextEditingController();
  final updateProductFormKey = GlobalKey<FormState>();
  bool isContinueDisabled = true;
  late FocusNode buyingPriceNode;
  late FocusNode sellingPriceNode;
  late FocusNode discountNode;
  late ProductModel product;
  bool status = false;

  @override
  void initState() {
    super.initState();

    buyingPriceNode = FocusNode();
    buyingPriceNode.addListener(() {
      if (!buyingPriceNode.hasFocus) {
        _formatCurrency(controllerBuying);
        buyingPriceNode.unfocus();
      }
    });
    sellingPriceNode = FocusNode();
    sellingPriceNode.addListener(() {
      if (!sellingPriceNode.hasFocus) {
        _formatCurrency(controllerSelling);
        sellingPriceNode.unfocus();
      }
    });
    discountNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UpdateProductCubit>().getProduct(widget.productId);
    });
  }

  void _formatCurrency(TextEditingController controller) {
    if ('' != controller.value.text) {
      var formatter = NumberFormat.currency(customPattern: '#,###.##');
      String amount = controller.value.text;
      if (!amount.contains('.')) {
        amount = "$amount.00";
      }
      amount = amount.replaceAll(',', '');
      String formattedAmount = formatter.format(double.parse(amount));
      controller.value = TextEditingValue(text: formattedAmount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    return BlocConsumer<UpdateProductCubit, UpdateProductState>(
      listener: (context, state) {
        state.maybeWhen(
            saved: (ProductModel product) {
              // context.read<UpdateProductCubit>().getProduct(widget.productId);
              CustomSnackBar.showSnackBar(
                  null, "Updated Successfully", 'success');
            },
            loaded: (ProductModel product) {
              this.product = product;
              controllerName.value =
                  TextEditingValue(text: product.name ?? "N/A");
              controllerBuying.value =
                  TextEditingValue(text: product.buying.toString());
              controllerSelling.value =
                  TextEditingValue(text: product.selling.toString());
              controllerQty.value =
                  TextEditingValue(text: product.quantity.toString());
              controllerDiscount.value =
                  TextEditingValue(text: product.discount.toString());
              controllerCode.value =
                  TextEditingValue(text: product.code ?? "N/A");
              status = product.status!;
              isContinueDisabled = false;
            },
            savingFailed: (message) {
              CustomSnackBar.showSnackBar(null, message, 'error');
            },
            loadingFailed: (message) {
              isContinueDisabled = true;
              CustomSnackBar.showSnackBar(null, message, 'error');
            },
            orElse: () {});
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
                      GoRouter.of(context).pop();
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
                    loaded: (ProductModel product) =>
                        _updateProductForm(context),
                    loadingFailed: (message) => _updateProductForm(context),
                    saving: () =>
                        const Center(child: CircularProgressIndicator()),
                    saved: (ProductModel product) =>
                        _updateProductForm(context),
                    savingFailed: (message) => _updateProductForm(context)),
                bottomNavigationBar: _bottomNavBar(context)));
      },
    );
  }

  _updateProductForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 6,
        ),
        Container(
          margin:
              const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 10),
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
                    Icons.inventory_2_rounded,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              const Text("Update Product",
                  style:
                      TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              // height: 100,
              padding: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 15, top: 10),
              margin: const EdgeInsets.only(
                  top: 8, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color:
                          Theme.of(context).colorScheme.scrim.withOpacity(0.2),
                      width: 1.0,
                      style: BorderStyle.solid),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                      offset: const Offset(0, 0),
                    )
                  ]),
              child: Form(
                key: updateProductFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Product Details",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                              child: Row(
                            children: [
                              const Text(
                                "Status",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 8),
                              Switch(
                                value: status,
                                onChanged: (bool value) {
                                  setState(() {
                                    status = value;
                                  });
                                },
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.labelLarge,
                        children: <TextSpan>[
                          const TextSpan(
                            text: "Name",
                          ),
                          TextSpan(
                            text: " *",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.red.withOpacity(0.85)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      controller: controllerName,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Cannot be empty.";
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9\s\-]')),
                        LengthLimitingTextInputFormatter(50)
                      ],
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        enabledBorder: CommonStyles.buildSharedInputBorder(),
                        focusedBorder: CommonStyles.buildFocusedInputBorder(),
                        border: CommonStyles.buildSharedInputBorder(),
                        hintText: 'Enter product name',
                      ),
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.labelLarge,
                        children: <TextSpan>[
                          const TextSpan(
                            text: "Code",
                          ),
                          TextSpan(
                            text: " *",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.red.withOpacity(0.85)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Cannot be empty.";
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-z0-9\-\s]')),
                        LengthLimitingTextInputFormatter(20)
                      ],
                      keyboardType: TextInputType.text,
                      controller: controllerCode,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        enabledBorder: CommonStyles.buildSharedInputBorder(),
                        focusedBorder: CommonStyles.buildFocusedInputBorder(),
                        border: CommonStyles.buildSharedInputBorder(),
                        hintText: 'Enter product code',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.labelLarge,
                        children: <TextSpan>[
                          const TextSpan(
                            text: "Buying Price",
                          ),
                          TextSpan(
                            text: " *",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.red.withOpacity(0.85)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      controller: controllerBuying,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Cannot be empty.";
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(15)
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        enabledBorder: CommonStyles.buildSharedInputBorder(),
                        focusedBorder: CommonStyles.buildFocusedInputBorder(),
                        border: CommonStyles.buildSharedInputBorder(),
                        hintText: '0.00',
                      ),
                      focusNode: buyingPriceNode,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.labelLarge,
                        children: <TextSpan>[
                          const TextSpan(
                            text: "Selling Price",
                          ),
                          TextSpan(
                            text: " *",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.red.withOpacity(0.85)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Cannot be empty.";
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(15)
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: controllerSelling,
                      onChanged: (value) {},
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        enabledBorder: CommonStyles.buildSharedInputBorder(),
                        focusedBorder: CommonStyles.buildFocusedInputBorder(),
                        border: CommonStyles.buildSharedInputBorder(),
                        hintText: '0.00',
                      ),
                      focusNode: sellingPriceNode,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.labelLarge,
                        children: <TextSpan>[
                          const TextSpan(
                            text: "Quantity",
                          ),
                          TextSpan(
                            text: " *",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.red.withOpacity(0.85)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Cannot be empty.";
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(15)
                      ],
                      keyboardType: TextInputType.number,
                      controller: controllerQty,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        enabledBorder: CommonStyles.buildSharedInputBorder(),
                        focusedBorder: CommonStyles.buildFocusedInputBorder(),
                        border: CommonStyles.buildSharedInputBorder(),
                        hintText: '00',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.labelLarge,
                        children: <TextSpan>[
                          const TextSpan(
                            text: "Discount",
                          ),
                          TextSpan(
                            text: " *",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.red.withOpacity(0.85)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Cannot be empty.";
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(5)
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: controllerDiscount,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        enabledBorder: CommonStyles.buildSharedInputBorder(),
                        focusedBorder: CommonStyles.buildFocusedInputBorder(),
                        border: CommonStyles.buildSharedInputBorder(),
                        hintText: '0.00',
                      ),
                      focusNode: discountNode,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _bottomNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<UpdateProductCubit, UpdateProductState>(
        builder: (context, state) {
          return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              saving: () => const Center(child: CircularProgressIndicator()),
              orElse: () => ElevatedButton(
                    onPressed: isContinueDisabled
                        ? null
                        : () {
                            if (updateProductFormKey.currentState!.validate()) {
                              product.name = controllerName.text.trim();
                              product.code = controllerCode.text.trim();
                              product.buying =
                                  double.parse(controllerBuying.text);
                              product.selling =
                                  double.parse(controllerSelling.text);
                              product.quantity = int.parse(controllerQty.text);
                              product.discount =
                                  double.parse(controllerDiscount.text);
                              product.status = status;
                              context
                                  .read<UpdateProductCubit>()
                                  .updateProduct(product);
                            }
                          },
                    style: CommonStyles.mainButtonStyles(),
                    child: Text('Update'.toUpperCase(),
                        style: CommonStyles.mainButtonTextStyle(
                            color: Theme.of(context).colorScheme.onPrimary)),
                  ));
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controllerSelling.dispose();
    controllerBuying.dispose();
    controllerCode.dispose();
    controllerDiscount.dispose();
    controllerQty.dispose();
    controllerName.dispose();
  }
}
