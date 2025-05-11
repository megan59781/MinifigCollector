import 'package:flutter/material.dart';
import 'package:minifig_collector_app/components/series_list.dart';
import 'package:minifig_collector_app/pages/inventory_page.dart';
import 'package:minifig_collector_app/pages/figure_filter_page.dart';

class MySeriesPage extends StatelessWidget {
  const MySeriesPage({super.key, required this.title, required this.pageLink});
  final String title;
  final String pageLink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary),
        body: Column(children: [
          const SizedBox(height: 20.0),
          const Text(
            'Choose a series to view the figures',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15.0),
          Expanded(
            child: SeriesList(
              pageLink: pageLink,
              onTap: (pageLink, title, data) {
                if (pageLink.contains('Filter')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FigureFilterPage(title: title, data: data),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Inventory(title: title, data: data),
                    ),
                  );
                }
              },
            ),
          ),
        ]));
  }
}
