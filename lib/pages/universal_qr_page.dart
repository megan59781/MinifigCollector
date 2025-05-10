import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:minifig_collector_app/components/qr_scanner.dart';

class MyUniversalQrPage extends StatefulWidget {
  const MyUniversalQrPage({super.key, required this.title});

  final String title;

  @override
  State<MyUniversalQrPage> createState() => _MyUniversalQrPageState();
}

class _MyUniversalQrPageState extends State<MyUniversalQrPage> {
  bool dataLoaded = false;
  Map<String, List<String>> loadedData = {};

  @override
  void initState() {
    super.initState();
    loadMinifigureData();
  }

  // load the minifigure data from JSON files in assets/codes
  Future<void> loadMinifigureData() async {
    final List<String> assetPaths = [
      'assets/codes/series25.json',
      'assets/codes/series26.json',
      'assets/codes/series27.json',
      'assets/codes/f1.json',
    ];

    Map<String, List<String>> tempFigureToCodes = {};
    Map<String, String> tempCodeToMinifigure = {};

    for (String path in assetPaths) {
      final String jsonStr = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonMap = json.decode(jsonStr);

      jsonMap.forEach((figure, codes) {
        List<String> codeList = List<String>.from(codes);
        if (tempFigureToCodes.containsKey(figure)) {
          tempFigureToCodes[figure]!.addAll(codeList);
        } else {
          tempFigureToCodes[figure] = codeList;
        }

        for (String code in codeList) {
          tempCodeToMinifigure[code] = figure;
        }
      });
    }

    setState(() {
      loadedData = tempFigureToCodes;
      dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: dataLoaded
            ? QrScanner(
                title: 'QR Scanner',
                data: loadedData,
                showBlockedStatus: false,
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
