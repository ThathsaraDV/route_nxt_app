import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  const EmptyWidget({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}