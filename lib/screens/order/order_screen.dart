import 'package:flutter/material.dart';
import 'package:nhanvien/models/order_item.dart';
import 'package:nhanvien/screens/order/pages/order_functions_page.dart';
import 'package:nhanvien/screens/order/pages/order_input_page.dart';
import 'package:nhanvien/screens/order/pages/order_menu_page.dart';
import 'package:nhanvien/screens/order/widgets/order_list_area.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late String tableNumber;
  final _pageController = PageController();
  final List<OrderItem> _orderedItems = [];
  int? _selectedItemIndex; // Thêm state để quản lý món được chọn

  @override
  void initState() {
    super.initState();
    tableNumber = 'N/A'; // Initialize with a default value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        setState(() {
          tableNumber = args;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addItemToOrder(String itemName) {
    setState(() {
      final existingItemIndex =
          _orderedItems.indexWhere((item) => item.name == itemName);
      if (existingItemIndex != -1) {
        _orderedItems[existingItemIndex].quantity++;
      } else {
        _orderedItems.add(OrderItem(name: itemName, price: 12.50)); // Assign a default price
      }
    });
  }

  // Thêm hàm để chọn món
  void _selectItem(int index) {
    setState(() {
      _selectedItemIndex = index;
    });
  }

  // Thêm hàm để tăng số lượng món đã chọn
  void _increaseSelectedItemQuantity() {
    if (_selectedItemIndex != null && _selectedItemIndex! < _orderedItems.length) {
      setState(() {
        _orderedItems[_selectedItemIndex!].quantity++;
      });
    }
  }

  // Thêm hàm để giảm số lượng món đã chọn
  void _decreaseSelectedItemQuantity() {
    if (_selectedItemIndex != null && _selectedItemIndex! < _orderedItems.length) {
      setState(() {
        final item = _orderedItems[_selectedItemIndex!];
        if (item.quantity > 1) {
          item.quantity--;
        } else {
          // Nếu số lượng = 1 thì xóa món khỏi danh sách
          _orderedItems.removeAt(_selectedItemIndex!);
          _selectedItemIndex = null; // Bỏ chọn món
        }
      });
    }
  }

  double get _totalOrderPrice => _orderedItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  Widget _buildDrawerItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      onTap: () {
        // Handle drawer item taps
        Scaffold.of(context).closeEndDrawer();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '$tableNumber | €${_totalOrderPrice.toStringAsFixed(2)}', // Display total price
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_center_focus),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      endDrawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6, // Adjust width as needed
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                ),
                child: const Text(
                  'Function',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
              _buildDrawerItem('Kunde', Icons.people_alt),
              _buildDrawerItem('Rabatt gesamt', Icons.percent),
              _buildDrawerItem('Rabatt einzeln', Icons.percent),
              _buildDrawerItem('Abbrechen', Icons.cancel),
              _buildDrawerItem('Tisch wechseln', Icons.auto_delete),
              _buildDrawerItem('Rechnung splitten', Icons.call_split),
              _buildDrawerItem('Tische wechseln', Icons.table_chart),
              _buildDrawerItem('Küche benachrichtigen', Icons.mail),
              _buildDrawerItem('Add Sumup Key', Icons.vpn_key),
              _buildDrawerItem('Küchenkommentar', Icons.chat_bubble),
              _buildDrawerItem('Spezielle Bestellung', Icons.receipt_long),
              _buildDrawerItem('Div. Getränke', Icons.local_bar),
              _buildDrawerItem('Div. Küche', Icons.restaurant),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(flex: 9, child: OrderListArea(
            orderedItems: _orderedItems,
            selectedItemIndex: _selectedItemIndex,
            onItemSelected: _selectItem,
          )), // Increased to ~45%
          Expanded(
            flex: 11, // Adjusted accordingly
            child: PageView(
              controller: _pageController,
              children: [
                OrderInputPage(
                  onIncreaseQuantity: _increaseSelectedItemQuantity,
                  onDecreaseQuantity: _decreaseSelectedItemQuantity,
                ),
                OrderMenuPage(
                  onAddItem: _addItemToOrder,
                  onIncreaseQuantity: _increaseSelectedItemQuantity,
                  onDecreaseQuantity: _decreaseSelectedItemQuantity,
                ),
                OrderFunctionsPage(
                  onAddItem: _addItemToOrder,
                  onIncreaseQuantity: _increaseSelectedItemQuantity,
                  onDecreaseQuantity: _decreaseSelectedItemQuantity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 