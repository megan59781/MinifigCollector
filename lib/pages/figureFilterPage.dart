import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FigureFilterPage extends StatefulWidget {
  final String title;
  final Map<String, dynamic> data;

  const FigureFilterPage({super.key, required this.title, required this.data});

  @override
  State<FigureFilterPage> createState() => _FigureFilterPageState();
}

class _FigureFilterPageState extends State<FigureFilterPage> {
  final Map<String, bool> _checkedItems = {};
  final MobileScannerController _controller = MobileScannerController();
  String? _scannedCode; // To store scanned QR code
  String _matchedMinifigure = ''; // To store the matched result

  @override
  void initState() {
    super.initState();
    widget.data.keys.forEach((key) {
      _checkedItems[key] = false; // Initially unchecked
    });
  }

  // Update the onDetect method signature to accept BarcodeCapture
  void _onDetect(BarcodeCapture barcodeCapture) {
    final barcode = barcodeCapture.barcodes.first; // Assuming only one barcode
    final value = barcode.rawValue;

    if (value == null) return;

    final code = value.split(' ').first.trim();
    print('Raw QR value: $value');
    print('First extracted code: "$code"');

    setState(() {
      _scannedCode = code; // Store scanned code
      _matchedMinifigure = _getMatchResult(code); // Get match result
    });
  }

  // Function to get the match result based on the scanned QR code
  String _getMatchResult(String code) {
    bool isBlocked = false;
    widget.data.forEach((name, codes) {
      if (_checkedItems[name] == true) {
        // Only check for selected (checked) names
        if ((codes as List).contains(code)) {
          isBlocked = true;
        }
      }
    });

    // Return appropriate message based on match result
    if (isBlocked) {
      return 'This QR is in the blocked list.';
    } else if (widget.data.values
        .any((codes) => (codes as List).contains(code))) {
      return 'This QR is known but not blocked.';
    } else {
      return 'This QR is unknown.';
    }
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
                  controlAffinity:
                      ListTileControlAffinity.leading, // Checkbox on the left
                  title: Text(name),
                  subtitle: Text(codes),
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
                // Open QR scanner when button is pressed
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text('QR Scanner'),
                        automaticallyImplyLeading:
                            false, // Disable default back button
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context); // Close the scanner dialog
                          },
                        ),
                      ),
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // QR Scanner view
                          Expanded(
                            flex: 3,
                            child: MobileScanner(
                              controller: _controller,
                              fit: BoxFit.contain,
                              onDetect:
                                  _onDetect, // Pass the updated onDetect method
                            ),
                          ),
                          // Display scan result below the scanner
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: _scannedCode == null
                                  ? const Text('Scan a QR code to get started.')
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('Scanned Code: $_scannedCode',
                                            textAlign: TextAlign.center),
                                        const SizedBox(height: 10),
                                        Text('Result: $_matchedMinifigure',
                                            textAlign: TextAlign.center),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Text('Hello'),
            ),
          ),
        ],
      ),
    );
  }
}
