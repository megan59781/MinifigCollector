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
          Expanded(
            child: ListView(
              children: widget.data.entries.map((entry) {
                final name = entry.key;
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(name),
                  value: _checkedItems[name] ?? false,
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
