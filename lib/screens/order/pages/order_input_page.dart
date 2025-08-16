import 'package:flutter/material.dart';
import 'package:nhanvien/screens/order/widgets/bottom_actions.dart';
import 'package:nhanvien/models/order_item.dart';

class OrderInputPage extends StatefulWidget {
  final VoidCallback? onIncreaseQuantity;
  final VoidCallback? onDecreaseQuantity;
  final Function(String)? onGangChanged;
  final VoidCallback? onToggleGangEditMode;
  final VoidCallback? onDeleteItem;
  final VoidCallback? onShowComment;
  final VoidCallback? onAddItemWithoutNote;
  final String currentGang;
  final bool isGangEditMode;
  final List<OrderItem> orderedItems;
  final double totalAmount;
  final String tableNumber;
  
  const OrderInputPage({
    super.key, 
    this.onIncreaseQuantity,
    this.onDecreaseQuantity,
    this.onGangChanged,
    this.onToggleGangEditMode,
    this.onDeleteItem,
    this.onShowComment,
    this.onAddItemWithoutNote,
    required this.currentGang,
    required this.isGangEditMode,
    required this.orderedItems,
    required this.totalAmount,
    required this.tableNumber,
  });

  @override
  State<OrderInputPage> createState() => _OrderInputPageState();
}

class _OrderInputPageState extends State<OrderInputPage> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _onInput(String value) {
    setState(() {
      if (value == 'backspace') {
        if (_inputController.text.isNotEmpty) {
          _inputController.text =
              _inputController.text.substring(0, _inputController.text.length - 1);
        }
      } else {
        _inputController.text += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInputToolbar(),
        Expanded(flex: 5, child: _buildInputPad()),
        BottomActions(
          orderItems: widget.orderedItems.map((item) => {
            'name': item.name,
            'quantity': item.quantity,
            'price': item.price,
          }).toList(),
          totalAmount: widget.totalAmount,
          tableNumber: widget.tableNumber,
        ),
      ],
    );
  }

  Widget _buildInputToolbar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 2), // Reduced from 4,0,4,4
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: widget.onIncreaseQuantity, 
                icon: const Icon(Icons.add)
              ),
              IconButton(
                onPressed: widget.onDecreaseQuantity, 
                icon: const Icon(Icons.remove)
              ),
              IconButton(
                onPressed: widget.onDeleteItem, 
                icon: const Icon(Icons.close)
              ),
              IconButton(
                onPressed: widget.onShowComment, 
                icon: const Icon(Icons.chat_bubble_outline)
              ),
              ElevatedButton(
                onPressed: widget.onAddItemWithoutNote, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade100,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(8),
                  minimumSize: const Size(40, 40),
                ),
                child: const Text(
                  '+*',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              _toolbarButton('G', isSelected: widget.isGangEditMode, onPressed: widget.onToggleGangEditMode),
              _toolbarButton('G1', isSelected: widget.currentGang == 'G1'),
              _toolbarButton('G2', isSelected: widget.currentGang == 'G2'),
              _toolbarButton('---'),
            ],
          ),
          Container(
            width: 70,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              _inputController.text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolbarButton(String text, {bool isSelected = false, VoidCallback? onPressed}) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        minimumSize: const Size(20, 20),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: isSelected ? Colors.orange.shade100 : null,
      ),
      onPressed: onPressed ?? () {
        if (text.startsWith('G') && text != 'G' && widget.onGangChanged != null) {
          widget.onGangChanged!(text);
        }
      },
      child: Text(
        text, 
        style: TextStyle(
          color: isSelected ? Colors.orange.shade700 : Colors.black, 
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        )
      ),
    );
  }

  Widget _buildInputPad() {
    return Container(
      padding: const EdgeInsets.all(2),
      color: Colors.grey[300],
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3, // Reverted to 4 as in image
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: 3.0, // Further adjusted to make buttons flatter
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ...['7', '8', '9', '4', '5', '6', '1', '2', '3', '0', '*', '']
                        .map((k) => _inputKey(k, isNumeric: true)),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _inputKey('backspace', icon: Icons.arrow_back),
                    _inputKey('Artikel'),
                  ],
                ),
              ),
            ],
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 4.0, // Further adjusted to make buttons flatter
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
                  .map((k) => _inputKey(k)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputKey(String text, {IconData? icon, bool isNumeric = false}) {
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      child: ElevatedButton(
          onPressed: () => _onInput(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: isNumeric ? Colors.blue[100] : Colors.grey[50],
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            padding: EdgeInsets.zero, // Added to reduce button height
          ),
          child: icon != null ? Icon(icon) : Text(text, style: const TextStyle(fontSize: 16)),
        ),
    );
  }
} 