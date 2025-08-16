class OrderItem {
  final String name;
  int quantity;
  final double price; // Added price field
  String gang; // Thêm trường gang để phân loại
  String note; // Thêm trường note để lưu ghi chú
  double extraPrice; // Thêm trường extraPrice để lưu giá phụ thêm

  OrderItem({
    required this.name, 
    this.quantity = 1, 
    required this.price,
    this.gang = 'G1', // Mặc định là G1
    this.note = '', // Mặc định note rỗng
    this.extraPrice = 0.0, // Mặc định giá phụ là 0
  });
} 