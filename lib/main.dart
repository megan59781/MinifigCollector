import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
