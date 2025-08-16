import 'package:flutter/material.dart';

class MenuToolbar extends StatelessWidget {
  final VoidCallback? onIncreaseQuantity;
  final VoidCallback? onDecreaseQuantity;
  final Function(String)? onGangChanged;
  final VoidCallback? onToggleGangEditMode;
  final VoidCallback? onDeleteItem;
  final VoidCallback? onShowComment;
  final VoidCallback? onAddItemWithoutNote;
  final String currentGang;
  final bool isGangEditMode;
  
  const MenuToolbar({
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          IconButton(
            onPressed: onIncreaseQuantity, 
            icon: const Icon(Icons.add)
          ),
          IconButton(
            onPressed: onDecreaseQuantity, 
            icon: const Icon(Icons.remove)
          ),
          IconButton(
            onPressed: onDeleteItem, 
            icon: const Icon(Icons.close)
          ),
          IconButton(
            onPressed: onShowComment, 
            icon: const Icon(Icons.chat_bubble_outline)
          ),
          ElevatedButton(
            onPressed: onAddItemWithoutNote, 
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
          _toolbarButton('G', isSelected: isGangEditMode, onPressed: onToggleGangEditMode),
          _toolbarButton('G1', isSelected: currentGang == 'G1'),
          _toolbarButton('G2', isSelected: currentGang == 'G2'),
          _toolbarButton('---'),
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
        if (text.startsWith('G') && text != 'G' && onGangChanged != null) {
          onGangChanged!(text);
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
} 