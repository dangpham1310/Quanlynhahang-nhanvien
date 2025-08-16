import 'package:flutter/material.dart';
import 'package:nhanvien/screens/order/widgets/bottom_actions.dart';
import 'package:nhanvien/screens/order/widgets/menu_toolbar.dart';
import 'package:nhanvien/models/order_item.dart';

class OrderMenuPage extends StatefulWidget {
  final Function(String) onAddItem;
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
  
  const OrderMenuPage({
    super.key, 
    required this.onAddItem,
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
  State<OrderMenuPage> createState() => _OrderMenuPageState();
}

class _OrderMenuPageState extends State<OrderMenuPage>
    with TickerProviderStateMixin {
  late TabController _menuTabController;
  final Map<String, List<String>> _menuData = {
    "MITTAGSMENU": [
      "L1 Mittag 1 M1-M6-N1", "L2 Mittag 2 M3-M5-N3", "L3 Mittag 3 U6-N3", "L4 Mittag 4 C1-N1",
      "L5 Mittag 5 C3-M6", "L6 Mittag 6 M5-M6-Nigiri Avocado", "L7 Mittag 7 Nudeln mit Gemüse", "L8 Mittag 8 Nudeln mit Huhn",
      "L9 Mittag 9 Nudeln mit Ente", "L10 Mittag 10 Dundeln Sosser mit Gemüse", "L11 Mittag 11 Dunkelnsosser mit", "L12 Mittag 12 Currysosser mit Ente",
      "L13 Mittag 13 Curry mit Tofu", "L14 Mittag 14 Lemongrass Sosser mit", "L15 Mittag 15 Lemongrass Sosser mit", "Div.Kuche",
      "Div.Getränk", "D1 Coco Passion", "D2. Cheesecake", "D3 Chocolatte Lava Cake",
      "D4 Vietnamese Banh Ran", "78. Aperol Spritz 0,2l (4cl Aperol, 12cl)",
    ],
    "ASIAN TAPAS": List.generate(8, (i) => "Tapa ${i + 1}"),
    "VOM GRILL": List.generate(6, (i) => "Grill Dish ${i + 1}"),
    "SUSHI HAUS": List.generate(10, (i) => "Sushi ${i + 1}"),
  };

  @override
  void initState() {
    super.initState();
    _menuTabController = TabController(length: _menuData.keys.length, vsync: this);
  }

  @override
  void dispose() {
    _menuTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MenuToolbar(
          onIncreaseQuantity: widget.onIncreaseQuantity,
          onDecreaseQuantity: widget.onDecreaseQuantity,
          onGangChanged: widget.onGangChanged,
          onToggleGangEditMode: widget.onToggleGangEditMode,
          onDeleteItem: widget.onDeleteItem,
          onShowComment: widget.onShowComment,
          onAddItemWithoutNote: widget.onAddItemWithoutNote,
          currentGang: widget.currentGang,
          isGangEditMode: widget.isGangEditMode,
        ),
        _buildMenuTabBar(),
        Expanded(
          flex: 5,
          child: Container(
            color: const Color(0xFF212121),
            child: TabBarView(
              controller: _menuTabController,
              children: _menuData.keys.map((category) {
                return _buildMenuItemGrid(_menuData[category]!);
              }).toList(),
            ),
          ),
        ),
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

  Widget _buildMenuTabBar() {
    return Container(
      color: const Color(0xFF303F9F), // Dark blue for the tab bar background
      child: TabBar(
        controller: _menuTabController,
        isScrollable: true,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.lightGreenAccent.shade400, // Vibrant green for selected tab
        ),
        tabs: _menuData.keys.map((title) {
          return Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItemGrid(List<String> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(2), // Reduced from 4
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2.0,
        mainAxisSpacing: 2, // Reduced from 4
        crossAxisSpacing: 2, // Reduced from 4
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ElevatedButton(
          onPressed: () => widget.onAddItem(item),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
              side: BorderSide(color: Colors.grey.shade500),
            ),
            padding: const EdgeInsets.all(4),
            alignment: Alignment.center,
          ),
          child: Text(
            item,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }
} 