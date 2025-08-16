import 'package:flutter/material.dart';
import 'package:nhanvien/screens/order/widgets/bottom_actions.dart';
import 'package:nhanvien/screens/order/widgets/menu_toolbar.dart';
import 'package:nhanvien/models/order_item.dart';

class OrderFunctionsPage extends StatefulWidget {
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
  
  const OrderFunctionsPage({
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
  State<OrderFunctionsPage> createState() => _OrderFunctionsPageState();
}

class _OrderFunctionsPageState extends State<OrderFunctionsPage> {
  final _searchController = TextEditingController();
  List<String> _allMenuItems = [];
  List<String> _filteredMenuItems = [];

  // TODO: This data should be provided by a service or state management solution
  final Map<String, List<String>> _menuData = {
    "MITTAGSMENUU": [
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
    // Flatten the menu data into a single list for searching
    _allMenuItems = _menuData.values.expand((items) => items).toList();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredMenuItems = [];
      });
      return;
    }

    setState(() {
      _filteredMenuItems = _allMenuItems
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0), // Reduced from 8.0, 4.0
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search by name',
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () {
                  // TODO: Implement voice search
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: _filteredMenuItems.isEmpty && _searchController.text.isNotEmpty
              ? const Center(child: Text('No items found.'))
              : ListView.builder(
                  itemCount: _filteredMenuItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredMenuItems[index];
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        widget.onAddItem(item);
                        _searchController.clear();
                      },
                    );
                  },
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
} 