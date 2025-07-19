import 'package:flutter/material.dart';

class BottomActions extends StatelessWidget {
  const BottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _bottomAction('BESTELLEN'), // Order
        _bottomAction('ABSCHLUSS'), // Finish
      ],
    );
  }

  Widget _bottomAction(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0), // Reduced from 4.0
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 12), // Reduced from 16
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
              side: BorderSide(color: Colors.grey.shade400),
            ),
            elevation: 2,
          ),
          child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // Reduced from 16
        ),
      ),
    );
  }
} 