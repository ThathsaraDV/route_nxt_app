import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:route_nxt/config/constants/common_styles.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerBuying = TextEditingController();
  final TextEditingController controllerSelling = TextEditingController();
  final TextEditingController controllerQty = TextEditingController();
  final TextEditingController controllerDiscount = TextEditingController();
  final TextEditingController controllerCode = TextEditingController();
  final newProductFormKey = GlobalKey<FormState>();
  bool isContinueDisabled = false;
  late FocusNode buyingPriceNode;
  late FocusNode sellingPriceNode;
  late FocusNode discountNode;

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
            body: _newProductForm(context),
            bottomNavigationBar: _bottomNavBar(context)));
  }

  _newProductForm(BuildContext context) {
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
              const Text("Add New Product",
                  style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600)),
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
                    color: Theme.of(context).colorScheme.scrim.withOpacity(0.2),
                    width: 1.0,
                    style: BorderStyle.solid),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .shadow
                        .withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .shadow
                        .withOpacity(0.1),
                    offset: const Offset(0,0),
                  )
                ]
              ),
              child: Form(
                key: newProductFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Product Details",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
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
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
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
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: controllerSelling,
                      onChanged: (value) {},
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
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
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: controllerDiscount,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
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
      child: ElevatedButton(
        onPressed: isContinueDisabled
            ? null
            : () {
                if (newProductFormKey.currentState!.validate()) {}
              },
        style: CommonStyles.mainButtonStyles(),
        child: Text('submit'.toUpperCase(),
            style: CommonStyles.mainButtonTextStyle(
                color: Theme.of(context).colorScheme.onPrimary)),
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
