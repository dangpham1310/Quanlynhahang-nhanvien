import 'package:flutter/material.dart';
import 'package:nhanvien/models/order_item.dart';

class OrderListArea extends StatelessWidget {
  final List<OrderItem> orderedItems;
  final int? selectedItemIndex;
  final Function(int)? onItemSelected;
  
  const OrderListArea({
    super.key, 
    required this.orderedItems,
    this.selectedItemIndex,
    this.onItemSelected,
  });

  // double get _totalPrice => orderedItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity)); // Removed

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 150, // Removed fixed height
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: orderedItems.isEmpty
          ? const Center(
              child: Text(
                'Ordered items will appear here...',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: orderedItems.length,
              itemBuilder: (context, index) {
                final item = orderedItems[index];
                final isSelected = selectedItemIndex == index;
                
                return GestureDetector(
                  onTap: () => onItemSelected?.call(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade100 : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: isSelected ? Border.all(color: Colors.blue.shade300, width: 2) : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        )),
                        Expanded(flex: 1, child: Text(
                          item.quantity.toString(), 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        )),
                        Expanded(flex: 1, child: Text(
                          '€${(item.price * item.quantity).toStringAsFixed(2)}', 
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        )),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
} 