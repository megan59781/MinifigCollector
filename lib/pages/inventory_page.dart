import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Inventory extends StatefulWidget {
  const Inventory({super.key, required this.title, required this.data});

  final String title;
  final Map<String, List<String>> data;

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final Map<String, bool> _checkedItems = {};

  @override
  void initState() {
    super.initState();
    _loadCheckedItems();
  }

  // Load the checked items from SharedPreferences
  Future<void> _loadCheckedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('checkedItems_${widget.title}');
    final Map<String, dynamic> savedMap =
        saved != null ? jsonDecode(saved) : {};

    setState(() {
      for (var key in widget.data.keys) {
        _checkedItems[key] = savedMap[key] ?? false;
      }
    });
  }

  Future<void> _saveCheckedItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'checkedItems_${widget.title}', jsonEncode(_checkedItems));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          const Text(
            'Select the figures you own to keep track of your collection',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15.0),
          Expanded(
            child: ListView(
              children: widget.data.entries.map((entry) {
                final name = entry.key;
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(name),
                  value: _checkedItems[name] ?? false,
                  activeColor: Colors.red[700]!,
                  onChanged: (bool? value) {
                    setState(() {
                      _checkedItems[name] = value ?? false;
                    });
                    _saveCheckedItems();
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
