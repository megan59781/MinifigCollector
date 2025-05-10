import 'package:flutter/material.dart';
import 'package:minifig_collector_app/page2.dart';
import 'package:minifig_collector_app/page3.dart';
import 'package:minifig_collector_app/universalQrPage.dart';

// Define WorkerNavigationBar widget
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
        // const Page3(
        //   title: 'Page 3',
        // ),
        const MyUniversalQrPage(
          title: 'Universal Minifigure QR Scanner',
        ),
        const Page2(
          title: 'Page 2',
        )
      ];

  // It updates the selected index and triggers a rebuild of the widget.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build the Scaffold widget
    return Scaffold(
      body: Center(
        child: _widgetOptions()[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.calendar_month_outlined),
          //   label: 'Availability', //Page3
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_2_outlined),
            label: 'Universal Qr Scanner', //UniversalQrPage
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_outlined),
            label: 'Mini Fig Filter', //Page2
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}
