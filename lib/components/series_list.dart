import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class SeriesList extends StatefulWidget {
  const SeriesList({
    super.key,
    required this.pageLink,
    required this.onTap,
  });

  final String pageLink;
  final void Function(
      String pageLink, String title, Map<String, List<String>> data) onTap;

  @override
  State<SeriesList> createState() => _SeriesListState();
}

class _SeriesListState extends State<SeriesList> {
  List<_JsonFile> _files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final indexJson = await rootBundle.loadString('assets/codes/index.json');
    final List<dynamic> fileList = json.decode(indexJson);

    List<_JsonFile> files = [];
    for (final item in fileList) {
      final name = item['name'] ?? 'Unnamed';
      final path = item['path'];
      final content = await rootBundle.loadString(path);
      final Map<String, dynamic> data = json.decode(content);
      Map<String, List<String>> transformedData = {};
      data.forEach((figure, codes) {
        if (codes is List) {
          transformedData[figure] = List<String>.from(codes);
        }
      });

      files.add(_JsonFile(name: name, data: transformedData));
    }

    setState(() {
      _files = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_files.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _files.length,
      itemBuilder: (context, index) {
        final file = _files[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(file.name),
            onTap: () => widget.onTap(widget.pageLink, file.name, file.data),
          ),
        );
      },
    );
  }
}

class _JsonFile {
  final String name;
  final Map<String, List<String>> data;

  _JsonFile({required this.name, required this.data});
}
