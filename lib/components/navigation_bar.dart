import 'package:flutter/material.dart';
import 'package:minifig_collector_app/pages/series_page.dart';
import 'package:minifig_collector_app/pages/universal_qr_page.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => MyNavigationBarState();
}

class MyNavigationBarState extends State<MyNavigationBar> {
  // Constructor
  MyNavigationBarState() {
    _selectedIndex = 0;
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // Page widget options
  static List<Widget> _widgetOptions() => [
        const MySeriesPage(
          title: 'Owned Figures Series',
          pageLink: 'Inventory',
        ),
        const MyUniversalQrPage(
          title: 'Universal Minifigure QR Scanner',
        ),
        const MySeriesPage(
          title: 'Mini Figure Series',
          pageLink: 'Filter',
        )
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions()[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Owned Figures', //SeriesPage > Inventory
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_2_outlined),
            label: 'Universal Qr Scanner', //UniversalQrPage
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_outlined),
            label: 'Mini Fig Filter', //SeriesPage > FilterFigures
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}
