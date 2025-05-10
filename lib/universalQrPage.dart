import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MyUniversalQrPage extends StatefulWidget {
  const MyUniversalQrPage({super.key, required this.title});

  final String title;

  @override
  State<MyUniversalQrPage> createState() => _MyUniversalQrPageState();
}

class _MyUniversalQrPageState extends State<MyUniversalQrPage> {
  String? scannedCode;
  String? matchedMinifigure;
  late final Map<String, String> codeToMinifigure;

  // series 27 codes
  final Map<String, List<String>> figureToCodes = {
    'Wolfpack Beastmaster': ['6522993', '6522981', '6522666'],
    'Hamster Costume Fan': ['6522994', '6522982', '6522667'],
    'Longboarder': ['6522995', '6522983', '6522668'],
    'Steampunk Inventor': ['6522996', '6522984', '6522669'],
    'Cupid': ['6522997', '6522985', '6522670'],
    'Jetpack Racer': ['6522998', '6522986', '6522671'],
    'Pirate Quartermaster': ['6522999', '6522987', '6522672'],
    'Pterodactyl Costume Fan': ['6523000', '6522988', '6522673'],
    'Telescope Kid': ['6523001', '6522989', '6522674'],
    'Crazy Cat Lover': ['6523002', '6522990', '6522675'],
    'Plush Toy Collector': ['6523003', '6522991', '6522676'],
    'Bogeyman': ['6523004', '6522992', '6522677'],
  };

  @override
  void initState() {
    super.initState();
    codeToMinifigure = _reverseFigCodeMap(figureToCodes);
  }

  Map<String, String> _reverseFigCodeMap(Map<String, List<String>> input) {
    final Map<String, String> reversed = {};
    input.forEach((minifig, codes) {
      for (var code in codes) {
        reversed[code] = minifig;
      }
    });
    return reversed;
  }

  // function that handles barcode detection
  void _onDetect(BarcodeCapture capture) {
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
