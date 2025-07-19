import 'package:flutter/material.dart';

class MenuToolbar extends StatelessWidget {
  final VoidCallback? onIncreaseQuantity;
  final VoidCallback? onDecreaseQuantity;
  
  const MenuToolbar({
    super.key, 
    this.onIncreaseQuantity,
    this.onDecreaseQuantity,
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
          const Spacer(),
          _toolbarButton('G'),
          _toolbarButton('G1'),
          _toolbarButton('G2'),
          _toolbarButton('---'),
        ],
      ),
    );
  }

  Widget _toolbarButton(String text) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        minimumSize: const Size(20, 20),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {},
      child:
          Text(text, style: const TextStyle(color: Colors.black, fontSize: 14)),
    );
  }
} 