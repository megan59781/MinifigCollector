import 'package:flutter/material.dart';

class FigureFilterPage extends StatefulWidget {
  final String title;
  final Map<String, dynamic> data;

  const FigureFilterPage({super.key, required this.title, required this.data});

  @override
  State<FigureFilterPage> createState() => _FigureFilterPageState();
}

class _FigureFilterPageState extends State<FigureFilterPage> {
  final Map<String, bool> _checkedItems = {};

  @override
  void initState() {
    super.initState();
    widget.data.keys.forEach((key) {
      _checkedItems[key] = false; // initially all unchecked
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: widget.data.entries.map((entry) {
                final name = entry.key;
                final codes = (entry.value as List<dynamic>).join(', ');

                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(name),
                  //subtitle: Text(codes),
                  value: _checkedItems[name],
                  onChanged: (bool? value) {
                    setState(() {
                      _checkedItems[name] = value ?? false;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                print('Button pressed');
              },
              child: Text('tbc'),
            ),
          ),
        ],
      ),
    );
  }
}
