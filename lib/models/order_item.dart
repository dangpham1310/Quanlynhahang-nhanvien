class OrderItem {
  final String name;
  int quantity;
  final double price; // Added price field

  OrderItem({required this.name, this.quantity = 1, required this.price});
} 