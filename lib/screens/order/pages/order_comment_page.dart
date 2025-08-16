import 'package:flutter/material.dart';

class OrderCommentPage extends StatefulWidget {
  final VoidCallback? onBack;
  final Function(String)? onAddNote;
  final String? selectedNote;
  final Function(String)? onUpdateNote;
  final double selectedExtraPrice;
  final Function(int, double)? onUpdateExtraPrice;
  
  const OrderCommentPage({
    super.key, 
    this.onBack,
    this.onAddNote,
    this.selectedNote,
    this.onUpdateNote,
    this.selectedExtraPrice = 0.0,
    this.onUpdateExtraPrice,
  });

  @override
  State<OrderCommentPage> createState() => _OrderCommentPageState();
}

class _OrderCommentPageState extends State<OrderCommentPage> {
  final List<String> _commentCategories = [
    'Gang 2', '0 CAY', '0 TRUNG', '0 Rau', '0 Toi', '0 Hanh', 'MUI',
    'MANG VE', 'HUT', 'ii cay', '0 com', '0 Lac', 'DI HET',
    'CAY', 'MI TOFU', '0 Tofu', '0 Tieu', '0 MII', 'NAU NGAY',
  ];

  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _showNoteInput = false;
  bool _showPriceInput = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedNote != null && widget.selectedNote!.isNotEmpty) {
      _noteController.text = widget.selectedNote!;
      _showNoteInput = true;
    }
    _priceController.text = widget.selectedExtraPrice.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _handleAndemPress() {
    if (_showNoteInput && _noteController.text.isNotEmpty) {
      // Nếu đang hiển thị input và có nội dung, cập nhật note và quay lại
      widget.onUpdateNote?.call(_noteController.text);
      widget.onBack?.call();
    } else {
      // Nếu chưa hiển thị input hoặc input rỗng, hiển thị input
      setState(() {
        _showNoteInput = true;
        _noteController.clear();
      });
    }
  }

  void _handleClearAll() {
    setState(() {
      _noteController.clear();
      _showNoteInput = false;
    });
  }

  void _handleBackspace() {
    if (_noteController.text.isNotEmpty) {
      setState(() {
        _noteController.text = _noteController.text.substring(0, _noteController.text.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KOMMENTAR',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Column(
        children: [
          // Note input area (hiển thị khi cần)
          if (_showNoteInput)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border(bottom: BorderSide(color: Colors.blue.shade200)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ghi chú cho món:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nhập ghi chú...',
                    ),
                    maxLines: 3,
                    autofocus: true,
                    onChanged: (value) {
                      // Tự động format ghi chú thành các dòng riêng biệt
                      final comments = value.split(', ');
                      if (comments.length > 1) {
                        final formattedText = comments.map((comment) => '- $comment').join('\n');
                        if (formattedText != value) {
                          _noteController.text = formattedText;
                          _noteController.selection = TextSelection.fromPosition(
                            TextPosition(offset: formattedText.length),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          // Main grid of comment buttons
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: _commentCategories.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      // Thêm comment vào note
                      if (_showNoteInput) {
                        final currentText = _noteController.text;
                        if (currentText.isEmpty) {
                          _noteController.text = '- ${_commentCategories[index]}';
                        } else {
                          // Kiểm tra xem comment đã tồn tại chưa
                          final existingComments = currentText.split('\n').map((line) => line.replaceFirst('- ', '')).toList();
                          if (!existingComments.contains(_commentCategories[index])) {
                            final newText = '$currentText\n- ${_commentCategories[index]}';
                            _noteController.text = newText;
                          }
                        }
                      } else {
                        // Nếu chưa có input, tạo input mới với comment này
                        setState(() {
                          _showNoteInput = true;
                          _noteController.text = '- ${_commentCategories[index]}';
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 1,
                    ),
                    child: Text(
                      _commentCategories[index],
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),
          // Bottom action area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Ingredient price section
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPriceInput = !_showPriceInput;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: _showPriceInput
                        ? TextField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '0.00',
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            autofocus: true,
                            onSubmitted: (value) {
                              final extraPrice = double.tryParse(value) ?? 0.0;
                              widget.onUpdateExtraPrice?.call(0, extraPrice); // itemIndex sẽ được cập nhật sau
                              setState(() {
                                _showPriceInput = false;
                              });
                            },
                            onChanged: (value) {
                              final extraPrice = double.tryParse(value) ?? 0.0;
                              widget.onUpdateExtraPrice?.call(0, extraPrice); // itemIndex sẽ được cập nhật sau
                            },
                          )
                        : Row(
                            children: [
                              Icon(Icons.euro, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              const Text(
                                'Zatatenpreis',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '€${_priceController.text}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                // Action buttons section
                Row(
                  children: [
                    // Back button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: _handleBackspace,
                        icon: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Clear button
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: _handleClearAll,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'C',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Andem button
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade400, Colors.blue.shade500],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade200,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: _handleAndemPress,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Andem',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Abbruch button
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red.shade400, Colors.red.shade500],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.shade200,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            widget.onBack?.call();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Abbruch',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 