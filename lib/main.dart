import 'package:flutter/material.dart';
import 'package:minifig_collector_app/components/navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow[800]!),
        useMaterial3: true,
      ),
      home: const MyNavigationBar(),
    );
  }
}
