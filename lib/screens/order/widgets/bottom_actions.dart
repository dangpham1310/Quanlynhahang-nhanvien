import 'package:flutter/material.dart';

class BottomActions extends StatelessWidget {
  final List<Map<String, dynamic>> orderItems;
  final double totalAmount;
  final String tableNumber;
  
  const BottomActions({
    super.key,
    required this.orderItems,
    required this.totalAmount,
    required this.tableNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _bottomAction('BESTELLEN', () => _handleOrder(context)), // Order
        _bottomAction('ABSCHLUSS', () => _handleFinish(context)), // Finish
      ],
    );
  }

  Widget _bottomAction(String text, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0), // Reduced from 4.0
        child: ElevatedButton(
          onPressed: onPressed,
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

  void _handleOrder(BuildContext context) {
    // Xử lý đặt hàng
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đặt hàng được chọn')),
    );
  }

  void _handleFinish(BuildContext context) {
    // Chuyển đến màn hình thanh toán
    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        'totalAmount': totalAmount,
        'orderItems': orderItems,
        'tableNumber': tableNumber,
      },
    );
  }
} 