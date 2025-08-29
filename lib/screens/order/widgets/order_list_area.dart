import 'package:flutter/material.dart';
import 'package:nhanvien/models/order_item.dart';

class OrderListArea extends StatefulWidget {
  final List<OrderItem> orderedItems;
  final int? selectedItemIndex;
  final Function(int)? onItemSelected;
  final String currentGang;
  final bool isGangEditMode;
  final Function(int, String)? onUpdateNote;
  
  const OrderListArea({
    super.key, 
    required this.orderedItems,
    this.selectedItemIndex,
    this.onItemSelected,
    required this.currentGang,
    required this.isGangEditMode,
    this.onUpdateNote,
  });

  @override
  State<OrderListArea> createState() => _OrderListAreaState();
}

class _OrderListAreaState extends State<OrderListArea> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(OrderListArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Tự động cuộn xuống cuối khi có món mới được thêm
    if (widget.orderedItems.length > oldWidget.orderedItems.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
    
    // Tự động cuộn đến món được chọn mới
    if (widget.selectedItemIndex != oldWidget.selectedItemIndex && 
        widget.selectedItemIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          // Tìm vị trí của món được chọn trong danh sách đã sắp xếp
          final sortedItems = List<OrderItem>.from(widget.orderedItems);
          sortedItems.sort((a, b) {
            if (a.gang == 'G1' && b.gang == 'G2') return -1;
            if (a.gang == 'G2' && b.gang == 'G1') return 1;
            return 0;
          });
          
          final selectedItem = widget.orderedItems[widget.selectedItemIndex!];
          final selectedIndexInSorted = sortedItems.indexOf(selectedItem);
          
          if (selectedIndexInSorted != -1) {
            // Sử dụng GlobalKey để cuộn đến món được chọn
            final key = _itemKeys[widget.selectedItemIndex];
            if (key?.currentContext != null) {
              Scrollable.ensureVisible(
                key!.currentContext!,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                alignment: 0.3, // Căn giữa món được chọn
              );
            }
          }
        }
      });
    }
  }

  // Hàm để lấy màu cho từng Gang
  Color _getGangColor(String gang) {
    switch (gang) {
      case 'G1':
        return Colors.blue.shade100;
      case 'G2':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  // Hàm để lấy màu viền cho từng Gang
  Color _getGangBorderColor(String gang) {
    switch (gang) {
      case 'G1':
        return Colors.blue.shade300;
      case 'G2':
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  // Hàm để hiển thị dialog chỉnh sửa note
  void _showNoteEditDialog(BuildContext context, int itemIndex, String currentNote) {
    final noteController = TextEditingController(text: currentNote);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chỉnh sửa ghi chú'),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nhập ghi chú...',
            ),
            maxLines: 3,
            autofocus: true,
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
                widget.onUpdateNote?.call(itemIndex, noteController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sắp xếp danh sách theo Gang: G1 trước, G2 sau
    final sortedItems = List<OrderItem>.from(widget.orderedItems);
    sortedItems.sort((a, b) {
      if (a.gang == 'G1' && b.gang == 'G2') return -1;
      if (a.gang == 'G2' && b.gang == 'G1') return 1;
      return 0; // Cùng Gang thì giữ nguyên thứ tự
    });

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: sortedItems.isEmpty
          ? const Center(
              child: Text(
                'Ordered items will appear here...',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: sortedItems.length,
              itemBuilder: (context, index) {
                final item = sortedItems[index];
                // Tìm index thực tế trong danh sách gốc để xác định món được chọn
                final originalIndex = widget.orderedItems.indexOf(item);
                final isSelected = widget.selectedItemIndex == originalIndex;
                final gangColor = _getGangColor(item.gang);
                final gangBorderColor = _getGangBorderColor(item.gang);
                
                // Tạo hoặc lấy GlobalKey cho item này
                if (!_itemKeys.containsKey(originalIndex)) {
                  _itemKeys[originalIndex] = GlobalKey();
                }
                
                return GestureDetector(
                  onTap: () => widget.onItemSelected?.call(originalIndex),
                  child: Container(
                    key: _itemKeys[originalIndex],
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: isSelected ? gangColor.withOpacity(0.9) : gangColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                      border: isSelected 
                          ? Border.all(
                              color: widget.isGangEditMode ? Colors.orange : gangBorderColor, 
                              width: 2
                            ) 
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Tên món
                            Expanded(flex: 3, child: Text(
                              item.name,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            )),
                            // Số lượng
                            Expanded(flex: 1, child: Text(
                              item.quantity.toString(), 
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            )),
                            // Giá: hiển thị giá cũ (gạch đỏ) nếu có giảm, cạnh đó là giá mới
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Builder(
                                  builder: (context) {
                                    final double originalTotal = item.price * item.quantity;
                                    final bool hasDiscount = item.discountPercent > 0;
                                    final double discountedTotal = hasDiscount
                                        ? originalTotal * (1 - item.discountPercent / 100)
                                        : originalTotal;
                                    final TextStyle baseStyle = TextStyle(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    );
                                    return FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerRight,
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            if (hasDiscount)
                                              TextSpan(
                                                text: '€${originalTotal.toStringAsFixed(2)}  ',
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  decoration: TextDecoration.lineThrough,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            TextSpan(
                                              text: '€${discountedTotal.toStringAsFixed(2)}',
                                              style: baseStyle,
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.right,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Hiển thị note nếu có - dạng dòng riêng biệt
                        if (item.note.isNotEmpty)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: item.note.split(', ').map((comment) => 
                                Text(
                                  '- $comment',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              ).toList(),
                            ),
                          ),
                        // Hiển thị giá phụ thêm nếu có
                        if (item.extraPrice > 0)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              '+ €${item.extraPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
} 