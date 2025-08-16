import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _numberDisplayController = TextEditingController();
  String? _tableError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _numberDisplayController.dispose();
    super.dispose();
  }

  void _onNumpadInput(String input) {
    setState(() {
      if (input == 'backspace') {
        if (_numberDisplayController.text.isNotEmpty) {
          _numberDisplayController.text = _numberDisplayController.text
              .substring(0, _numberDisplayController.text.length - 1);
        }
        _tableError = null;
      } else if (input == 'enter') {
        if (_numberDisplayController.text.isNotEmpty) {
          final tableNum = int.tryParse(_numberDisplayController.text);
          if (tableNum == null || tableNum < 1 || tableNum > 30) {
            _tableError = 'Không có bàn đó';
          } else {
            _tableError = null;
            Navigator.pushNamed(
              context,
              '/order',
              arguments: _numberDisplayController.text,
            );
            _numberDisplayController.clear();
          }
        }
      } else {
        _numberDisplayController.text += input;
        _tableError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person_off_outlined), // Icon from image
          onPressed: () {
            // Navigate back to login screen
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        title: const Text('Tables'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Implement download action
            },
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          _buildCompactNumpad(),
          _buildAreaTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTableGrid(16, 'Room 1'),
                _buildTableGrid(8, 'Terrace'),
                _buildTableGrid(4, 'Takeaway'),
              ],
            ),
          ),
          _buildBottomMenu(),
        ],
      ),
    );
  }

  Widget _buildCompactNumpad() {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.grey[700],
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 80,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      _numberDisplayController.text,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 6,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: 1.4,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildNumpadKey('1'),
                    _buildNumpadKey('2'),
                    _buildNumpadKey('3'),
                    _buildNumpadKey('4'),
                    _buildNumpadKey('5'),
                    _buildNumpadKey('6'),
                    _buildNumpadKey('7'),
                    _buildNumpadKey('8'),
                    _buildNumpadKey('9'),
                    _buildNumpadKey('0'),
                    _buildNumpadKey('backspace', icon: Icons.backspace_outlined),
                    _buildNumpadKey('enter', text: 'Enter'),
                  ],
                ),
              ),
            ],
          ),
          if (_tableError != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _tableError!,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNumpadKey(String value, {String? text, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ElevatedButton(
        onPressed: () => _onNumpadInput(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: icon != null
            ? Icon(icon, size: 20)
            : Text(
                text ?? value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildAreaTabs() {
    return Container(
      color: Colors.grey[200],
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.blue,
        tabs: const [
          Tab(text: 'Room 1'), // RAUM1
          Tab(text: 'Terrace'), // TERRASS
          Tab(text: 'Takeaway'), // MITNEHMEN
        ],
      ),
    );
  }

  Widget _buildTableGrid(int count, String areaName) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/order',
              arguments: (index + 1).toString(),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.grey[400]!),
            ),
          ),
          child: Text(
            '${index + 1}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Widget _buildBottomMenu() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomButton('Table Plan', isActive: true), // TISCHPLAN
              _buildBottomButton('Open Tables'), // OFFENE TISCHE
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomButton('Takeaway'), // MITNEHMEN
              _buildBottomButton('Waiting List'), // WARTELISTE
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(String text, {bool isActive = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: isActive ? Colors.red : Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text(text),
        ),
      ),
    );
  }
} 