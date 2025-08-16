import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> orderItems;
  final String tableNumber;
  
  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.orderItems,
    required this.tableNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Transform.rotate(
        angle: 3.14159, // 180 degrees in radians
        child: Column(
          children: [
            // Top bar with system info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '14:16 Fr., 18. Juli',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.wifi, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        '45%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.battery_6_bar, size: 16, color: Colors.grey[600]),
                    ],
                  ),
                ],
              ),
            ),
            
                         // Main payment interface
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Column(
                   children: [
                     // Payment title
                     const Text(
                       'BEZAHLEN',
                       style: TextStyle(
                         fontSize: 28,
                         fontWeight: FontWeight.bold,
                         color: Colors.black87,
                       ),
                     ),
                     
                     const SizedBox(height: 24),
                    
                    // Payment buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildPaymentButton(
                            'BARGELD',
                            Colors.blue,
                            () => _handleCashPayment(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildPaymentButton(
                            'KARTENZAHLUNG',
                            Colors.red,
                            () => _handleCardPayment(context),
                          ),
                        ),
                      ],
                    ),
                    
                                         const SizedBox(height: 16),
                     
                     _buildPaymentButton(
                       'SUMUP',
                       Colors.green,
                       () => _handleSumupPayment(context),
                       fullWidth: true,
                     ),
                     
                     const SizedBox(height: 24),
                    
                                         // Total amount
                     Column(
                       children: [
                         // Tax and discount info
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(
                               'Steuer: ${(totalAmount * 0.16).toStringAsFixed(2)} €',
                               style: const TextStyle(
                                 fontSize: 14,
                                 color: Colors.grey,
                               ),
                             ),
                             Text(
                               'Rabatt: -1,34 €',
                               style: const TextStyle(
                                 fontSize: 14,
                                 color: Colors.grey,
                               ),
                             ),
                           ],
                         ),
                         const SizedBox(height: 16),
                         // Main total amount
                         Center(
                           child: Text(
                             '${totalAmount.toStringAsFixed(2)} €',
                             style: const TextStyle(
                               fontSize: 42,
                               fontWeight: FontWeight.bold,
                               color: Colors.black87,
                             ),
                           ),
                                                  ),
                       ],
                     ),
                     
                     const SizedBox(height: 24),
                    
                                         // Order items
                     Expanded(
                       child: Container(
                         padding: const EdgeInsets.all(12),
                         decoration: BoxDecoration(
                           border: Border.all(color: Colors.grey[300]!),
                           borderRadius: BorderRadius.circular(8),
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             const Text(
                               'Rechnung:',
                               style: TextStyle(
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                             const SizedBox(height: 12),
                             Expanded(
                               child: SingleChildScrollView(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     ...orderItems.map((item) => _buildOrderItem(
                                       item['name'] ?? '',
                                       item['quantity'] ?? 1,
                                       item['price'] ?? 0.0,
                                     )),
                                     const Divider(),
                                     _buildOrderItem('Rabatt Essen', 1, -1.34),
                                     _buildOrderItem('Rabatt Getränke', 1, 0.00),
                                   ],
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                  ],
                ),
              ),
            ),
            
            // Bottom bar with table number
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.black,
              child: Center(
                child: Text(
                  'Tische $tableNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton(String text, Color color, VoidCallback onPressed, {bool fullWidth = false}) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(String name, int quantity, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$quantity $name',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            '${price.toStringAsFixed(2)} €',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: price < 0 ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _handleCashPayment(BuildContext context) {
    // Navigate to cash payment screen
    Navigator.pushNamed(
      context,
      '/cash-payment',
      arguments: {
        'totalAmount': totalAmount,
        'orderItems': orderItems,
        'tableNumber': tableNumber,
      },
    );
  }

  void _handleCardPayment(BuildContext context) {
    // Xử lý thanh toán thẻ
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanh toán thẻ được chọn')),
    );
  }

  void _handleSumupPayment(BuildContext context) {
    // Xử lý thanh toán SumUp
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanh toán SumUp được chọn')),
    );
  }
}
