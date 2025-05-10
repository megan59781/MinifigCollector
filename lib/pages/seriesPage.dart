import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:minifig_collector_app/pages/figureFilterPage.dart';

class MySeriesPage extends StatefulWidget {
  const MySeriesPage({super.key, required this.title});

  final String title;

  @override
  State<MySeriesPage> createState() => _MySeriesPageState();
}

class _MySeriesPageState extends State<MySeriesPage> {
  List<_JsonFile> _files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    print("Loading files...");
    final indexJson = await rootBundle.loadString('assets/codes/index.json');
    final List<dynamic> fileList = json.decode(indexJson);
    print("indexJson: $indexJson");
    print("fileList: $fileList");

    List<_JsonFile> files = [];
    for (final item in fileList) {
      final name = item['name'] ?? 'Unnamed';
      final path = item['path'];
      final content = await rootBundle.loadString(path);
      final Map<String, dynamic> data = json.decode(content);
      files.add(_JsonFile(name: name, data: data));
    }

    setState(() {
      _files = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _files.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _files.length,
              itemBuilder: (context, index) {
                final file = _files[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(file.name),
                    //subtitle: Text(jsonEncode(file.data)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FigureFilterPage(
                            title: file.name,
                            data: file.data,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class _JsonFile {
  final String name;
  final Map<String, dynamic> data;

  _JsonFile({required this.name, required this.data});
}
