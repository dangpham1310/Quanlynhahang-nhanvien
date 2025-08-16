import 'package:flutter/material.dart';
import 'package:nhanvien/models/order_item.dart';
import 'package:nhanvien/screens/order/pages/order_functions_page.dart';
import 'package:nhanvien/screens/order/pages/order_input_page.dart';
import 'package:nhanvien/screens/order/pages/order_menu_page.dart';
import 'package:nhanvien/screens/order/pages/order_comment_page.dart';
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
  String _currentGang = 'G1'; // Thêm state để quản lý Gang hiện tại
  bool _isGangEditMode = false; // Thêm state để quản lý chế độ đổi Gang
  bool _showCommentPage = false; // Thêm state để quản lý hiển thị màn hình comment

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
          _orderedItems.indexWhere((item) => item.name == itemName && item.gang == _currentGang);
      if (existingItemIndex != -1) {
        _orderedItems[existingItemIndex].quantity++;
        // Tự động chọn món vừa tăng số lượng
        _selectedItemIndex = existingItemIndex;
      } else {
        _orderedItems.add(OrderItem(
          name: itemName, 
          price: 12.50,
          gang: _currentGang, // Sử dụng Gang hiện tại
        ));
        // Tự động chọn món vừa thêm (món cuối cùng)
        _selectedItemIndex = _orderedItems.length - 1;
      }
    });
  }

  // Thêm hàm để thêm món mà không có note
  void _addItemWithoutNote(String itemName) {
    setState(() {
      // Luôn thêm món mới, không tăng số lượng món cũ
      _orderedItems.add(OrderItem(
        name: itemName, 
        price: 12.50,
        gang: _currentGang,
        note: '', // Không có note
      ));
      // Tự động chọn món vừa thêm (món cuối cùng)
      _selectedItemIndex = _orderedItems.length - 1;
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
    // Nếu chưa chọn món nào và có món trong danh sách, tự động chọn món cuối cùng
    if (_selectedItemIndex == null && _orderedItems.isNotEmpty) {
      setState(() {
        _selectedItemIndex = _orderedItems.length - 1;
      });
    }
    
    // Tăng số lượng món đã chọn
    if (_selectedItemIndex != null && _selectedItemIndex! < _orderedItems.length) {
      setState(() {
        _orderedItems[_selectedItemIndex!].quantity++;
      });
    }
  }

  // Thêm hàm để giảm số lượng món đã chọn
  void _decreaseSelectedItemQuantity() {
    // Nếu chưa chọn món nào và có món trong danh sách, tự động chọn món cuối cùng
    if (_selectedItemIndex == null && _orderedItems.isNotEmpty) {
      setState(() {
        _selectedItemIndex = _orderedItems.length - 1;
      });
    }
    
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

  // Thêm hàm để thay đổi Gang hiện tại
  void _changeGang(String gang) {
    setState(() {
      if (_isGangEditMode && _selectedItemIndex != null) {
        // Nếu đang ở chế độ đổi Gang và có món được chọn
        _orderedItems[_selectedItemIndex!].gang = gang;
        _isGangEditMode = false; // Tắt chế độ đổi Gang
      } else {
        // Nếu không phải chế độ đổi Gang thì đổi Gang hiện tại
        _currentGang = gang;
        _selectedItemIndex = null; // Bỏ chọn món khi đổi Gang
      }
    });
  }

  // Thêm hàm để bật/tắt chế độ đổi Gang
  void _toggleGangEditMode() {
    setState(() {
      _isGangEditMode = !_isGangEditMode;
      if (!_isGangEditMode) {
        // Nếu tắt chế độ đổi Gang thì bỏ chọn món
        _selectedItemIndex = null;
      }
    });
  }

  // Thêm hàm để hiển thị màn hình comment
  void _openCommentPage() {
    setState(() {
      _showCommentPage = true;
    });
  }

  // Thêm hàm để ẩn màn hình comment
  void _closeCommentPage() {
    setState(() {
      _showCommentPage = false;
    });
  }

  // Thêm hàm để cập nhật note cho món
  void _updateItemNote(int itemIndex, String note) {
    setState(() {
      _orderedItems[itemIndex].note = note;
    });
  }

  // Thêm hàm để lấy note của món đã chọn
  String? _getSelectedItemNote() {
    if (_selectedItemIndex != null && _selectedItemIndex! < _orderedItems.length) {
      return _orderedItems[_selectedItemIndex!].note;
    }
    return null;
  }

  // Thêm hàm để lấy extraPrice của món đã chọn
  double _getSelectedItemExtraPrice() {
    if (_selectedItemIndex != null && _selectedItemIndex! < _orderedItems.length) {
      return _orderedItems[_selectedItemIndex!].extraPrice;
    }
    return 0.0;
  }

  // Thêm hàm để cập nhật extraPrice cho món
  void _updateItemExtraPrice(int itemIndex, double extraPrice) {
    setState(() {
      _orderedItems[itemIndex].extraPrice = extraPrice;
    });
  }

  // Thêm hàm để xóa món với xác thực admin
  void _deleteSelectedItem() {
    if (_selectedItemIndex == null) {
      // Hiển thị thông báo nếu chưa chọn món
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn món cần xóa'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Hiển thị dialog nhập password
    _showAdminPasswordDialog();
  }

  // Hiển thị dialog nhập password admin
  void _showAdminPasswordDialog() {
    final passwordController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác thực Admin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Vui lòng nhập password admin để xóa món:'),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                onSubmitted: (value) {
                  _verifyAdminPassword(value);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                _verifyAdminPassword(passwordController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  // Xác thực password và xóa món
  void _verifyAdminPassword(String password) {
    // Password admin mặc định là "admin123" - có thể thay đổi sau
    const adminPassword = "admin123";
    
    if (password == adminPassword) {
      setState(() {
        _orderedItems.removeAt(_selectedItemIndex!);
        _selectedItemIndex = null;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa món thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password không đúng'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  double get _totalOrderPrice => _orderedItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity) + (item.extraPrice * item.quantity));

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
    // Nếu đang hiển thị màn hình comment
    if (_showCommentPage) {
      return OrderCommentPage(
        onBack: _closeCommentPage,
        onAddNote: (note) {
          if (_selectedItemIndex != null) {
            _updateItemNote(_selectedItemIndex!, note);
          }
          _closeCommentPage();
        },
        selectedNote: _getSelectedItemNote(),
        onUpdateNote: (note) {
          if (_selectedItemIndex != null) {
            _updateItemNote(_selectedItemIndex!, note);
          }
        },
        selectedExtraPrice: _getSelectedItemExtraPrice(),
        onUpdateExtraPrice: (itemIndex, extraPrice) {
          if (_selectedItemIndex != null) {
            _updateItemExtraPrice(_selectedItemIndex!, extraPrice);
          }
        },
      );
    }

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
            currentGang: _currentGang,
            isGangEditMode: _isGangEditMode,
            onUpdateNote: _updateItemNote,
          )), // Increased to ~45%
          Expanded(
            flex: 11, // Adjusted accordingly
            child: PageView(
              controller: _pageController,
              children: [
                OrderInputPage(
                  onIncreaseQuantity: _increaseSelectedItemQuantity,
                  onDecreaseQuantity: _decreaseSelectedItemQuantity,
                  onGangChanged: _changeGang,
                  onToggleGangEditMode: _toggleGangEditMode,
                  onDeleteItem: _deleteSelectedItem,
                  onShowComment: _openCommentPage,
                  onAddItemWithoutNote: () {
                    // Thêm món mới riêng biệt với note rỗng
                    if (_selectedItemIndex != null && _selectedItemIndex! < _orderedItems.length) {
                      final selectedItem = _orderedItems[_selectedItemIndex!];
                      _addItemWithoutNote(selectedItem.name);
                    }
                  },
                  currentGang: _currentGang,
                  isGangEditMode: _isGangEditMode,
                  orderedItems: _orderedItems,
                  totalAmount: _totalOrderPrice,
                  tableNumber: tableNumber,
                ),
                OrderMenuPage(
                  onAddItem: _addItemToOrder,
                  onIncreaseQuantity: _increaseSelectedItemQuantity,
                  onDecreaseQuantity: _decreaseSelectedItemQuantity,
                  onGangChanged: _changeGang,
                  onToggleGangEditMode: _toggleGangEditMode,
                  onDeleteItem: _deleteSelectedItem,
                  onShowComment: _openCommentPage,
                  onAddItemWithoutNote: () {
                    // Thêm món cuối cùng được chọn với note rỗng
                    if (_selectedItemIndex != null && _selectedItemIndex! < _orderedItems.length) {
                      final selectedItem = _orderedItems[_selectedItemIndex!];
                      _addItemWithoutNote(selectedItem.name);
                    }
                  },
                  currentGang: _currentGang,
                  isGangEditMode: _isGangEditMode,
                  orderedItems: _orderedItems,
                  totalAmount: _totalOrderPrice,
                  tableNumber: tableNumber,
                ),
                OrderFunctionsPage(
                  onAddItem: _addItemToOrder,
                  onIncreaseQuantity: _increaseSelectedItemQuantity,
                  onDecreaseQuantity: _decreaseSelectedItemQuantity,
                  onGangChanged: _changeGang,
                  onToggleGangEditMode: _toggleGangEditMode,
                  onDeleteItem: _deleteSelectedItem,
                  onShowComment: _openCommentPage,
                  onAddItemWithoutNote: () {
                    // Thêm món cuối cùng được chọn với note rỗng
                    if (_selectedItemIndex != null && _selectedItemIndex! < _orderedItems.length) {
                      final selectedItem = _orderedItems[_selectedItemIndex!];
                      _addItemWithoutNote(selectedItem.name);
                    }
                  },
                  currentGang: _currentGang,
                  isGangEditMode: _isGangEditMode,
                  orderedItems: _orderedItems,
                  totalAmount: _totalOrderPrice,
                  tableNumber: tableNumber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 