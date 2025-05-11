import 'package:flutter/material.dart';
import 'package:minifig_collector_app/components/qr_scanner.dart';

class FigureFilterPage extends StatefulWidget {
  final String title;
  final Map<String, List<String>> data;

  const FigureFilterPage({super.key, required this.title, required this.data});

  @override
  State<FigureFilterPage> createState() => _FigureFilterPageState();
}

class _FigureFilterPageState extends State<FigureFilterPage> {
  final Map<String, bool> _checkedItems = {};

  @override
  void initState() {
    super.initState();
    for (var key in widget.data.keys) {
      _checkedItems[key] = false; // Initially unchecked
    }
  }

  // Navigate to QR scanner and handle the scanning process
  void _navigateToScanner() {
    List<String> blockedCodes = [];
    _checkedItems.forEach((key, value) {
      if (value) {
        blockedCodes.addAll(widget.data[key]!);
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScanner(
            title: widget.title,
            data: widget.data, // Pass data into the new QR page
            showDetails: false,
            blockedData: blockedCodes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          const Text(
            'Select the figures you don\'t want, then press the button to check if the box is worth buying',
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
                  controlAffinity:
                      ListTileControlAffinity.leading, // Checkbox on the left
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
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: _navigateToScanner,
              child: const Text('Check Box QR Codes'),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
