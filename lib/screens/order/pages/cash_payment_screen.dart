import 'package:flutter/material.dart';

class CashPaymentScreen extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> orderItems;
  final String tableNumber;

  const CashPaymentScreen({
    super.key,
    required this.totalAmount,
    required this.orderItems,
    required this.tableNumber,
  });

  @override
  State<CashPaymentScreen> createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  String givenAmount = '';
  double change = 0.0;

  void _addNumber(String number) {
    setState(() {
      givenAmount += number;
      _calculateChange();
    });
  }

  void _deleteLast() {
    if (givenAmount.isNotEmpty) {
      setState(() {
        givenAmount = givenAmount.substring(0, givenAmount.length - 1);
        _calculateChange();
      });
    }
  }

  void _clear() {
    setState(() {
      givenAmount = '';
      change = 0.0;
    });
  }

  void _calculateChange() {
    if (givenAmount.isNotEmpty) {
      double given = double.tryParse(givenAmount) ?? 0.0;
      setState(() {
        change = given - widget.totalAmount;
      });
    } else {
      setState(() {
        change = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top bar with system info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '14:17 Fr., 18. Juli',
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

          // Main header - Bargeld
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.blue,
            child: const Center(
              child: Text(
                'Bargeld',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Payment details section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Payment details row
                  Row(
                    children: [
                      // Left side - labels
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gegeben:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Summe:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Rückgeld:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Right side - values
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                givenAmount.isEmpty ? '0.00' : '${double.tryParse(givenAmount)?.toStringAsFixed(2) ?? '0.00'} €',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[100],
                              ),
                              child: Text(
                                '${widget.totalAmount.toStringAsFixed(2)} €',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(8),
                                color: change >= 0 ? Colors.green[100] : Colors.red[100],
                              ),
                              child: Text(
                                '${change.toStringAsFixed(2)} €',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: change >= 0 ? Colors.green[800] : Colors.red[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Action buttons row
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          'DRUCKEN',
                          Colors.red,
                          () => _handlePrint(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionButton(
                          'BEWIRTUNG',
                          Colors.green,
                          () => _handleEntertainment(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Numeric keypad and right buttons
                  Expanded(
                    child: Row(
                      children: [
                        // Numeric keypad
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              // Top row: 7, 8, 9
                              Row(
                                children: [
                                  Expanded(child: _buildNumberButton('7')),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildNumberButton('8')),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildNumberButton('9')),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Middle row: 4, 5, 6
                              Row(
                                children: [
                                  Expanded(child: _buildNumberButton('4')),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildNumberButton('5')),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildNumberButton('6')),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Bottom row: 1, 2, 3
                              Row(
                                children: [
                                  Expanded(child: _buildNumberButton('1')),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildNumberButton('2')),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildNumberButton('3')),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Zero row: 0, 00, .
                              Row(
                                children: [
                                  Expanded(child: _buildNumberButton('0')),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildNumberButton('00')),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildNumberButton('.')),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // 000 button
                              SizedBox(
                                width: double.infinity,
                                child: _buildNumberButton('000'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Right side buttons
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _buildActionButton(
                                'LÖSCHEN',
                                Colors.orange,
                                _deleteLast,
                                height: 50,
                              ),
                              const SizedBox(height: 8),
                              _buildActionButton(
                                '<--',
                                Colors.grey,
                                _deleteLast,
                                height: 50,
                              ),
                              const Spacer(),
                              _buildActionButton(
                                'ABBRECHEN',
                                Colors.grey[600]!,
                                () => Navigator.pop(context),
                                height: 80,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom navigation bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.grid_on, color: Colors.grey[600]),
                Icon(Icons.settings, color: Colors.grey[600]),
                Icon(Icons.folder, color: Colors.grey[600]),
                Icon(Icons.calendar_today, color: Colors.grey[600]),
                Icon(Icons.chat_bubble_outline, color: Colors.grey[600]),
                Icon(Icons.person, color: Colors.grey[600]),
                Icon(Icons.camera_alt, color: Colors.grey[600]),
                Icon(Icons.calculate, color: Colors.grey[600]),
                Icon(Icons.refresh, color: Colors.grey[600]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () => _addNumber(number),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed, {double? height}) {
    return SizedBox(
      height: height ?? 50,
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
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handlePrint() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Drucken. In hóa đơn')),
    );
  }

  void _handleEntertainment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bewirtung In hóa đơn hoàn thuế')),
    );
  }
}
