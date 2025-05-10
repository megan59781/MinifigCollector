import 'package:flutter/material.dart';
import 'package:minifig_collector_app/components/seriesList.dart';
import 'package:minifig_collector_app/page3.dart';
import 'package:minifig_collector_app/pages/figureFilterPage.dart';

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
      body: SeriesList(
        onTap: (title, data) {
          if (title.contains('Filter')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FigureFilterPage(title: title, data: data),
              ),
            );
          } else {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         FigureFilterPage(title: title, data: data),
            //   ),
            // );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Page3(title: title),
              ),
            );
          }
        },
      ),
    );
  }
}
