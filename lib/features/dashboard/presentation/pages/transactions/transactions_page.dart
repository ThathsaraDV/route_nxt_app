import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({
    super.key,
  });

  @override
  State<TransactionPage> createState() => _TransactionPage();

}

class _TransactionPage extends State<TransactionPage> {

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Transaction'),
        ],
      ),
    );
  }
}