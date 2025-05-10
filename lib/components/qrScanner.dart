import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key, required this.title, required this.data});

  final String title;
  final Map<String, List<String>> data;

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  String? scannedCode;
  String? matchedMinifigure;
  bool dataLoaded = false;

  Map<String, List<String>> figureToCodes = {};
  Map<String, String> codeToMinifigure = {};

  @override
  void initState() {
    super.initState();
    loadMinifigureData();
  }

  void loadMinifigureData() {
    widget.data.forEach((figure, codes) {
      List<String> codeList = List<String>.from(codes);
      if (figureToCodes.containsKey(figure)) {
        figureToCodes[figure]!.addAll(codeList);
      } else {
        figureToCodes[figure] = codeList;
      }

      for (String code in codeList) {
        codeToMinifigure[code] = figure;
      }
    });

    setState(() {
      dataLoaded = true;
    });
  }

  // Function that handles barcode detection
  void _onDetect(BarcodeCapture capture) {
    if (!dataLoaded) return;

    final barcode = capture.barcodes.first;
    final value = barcode.rawValue;

    if (value != null) {
      final firstCode = value.split(' ').first.trim();
      print('Raw QR value: $value');
      print('First extracted code: "$firstCode"');

      if (firstCode != scannedCode) {
        setState(() {
          scannedCode = firstCode;
          matchedMinifigure =
              codeToMinifigure[firstCode] ?? "Unknown Minifigure";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Expanded(
              flex: 3,
              child: MobileScanner(
                fit: BoxFit.contain,
                controller: MobileScannerController(
                    formats: [BarcodeFormat.qrCode, BarcodeFormat.dataMatrix]),
                onDetect: _onDetect,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: scannedCode == null
                    ? const Text('Scan the 2D barcode on the LEGO box')
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Scanned Code:\n$scannedCode',
                              textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          Text('Minifigure:\n$matchedMinifigure',
                              textAlign: TextAlign.center),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
