import 'package:flutter/material.dart';
import 'package:p3/pages/file_picker_page.dart';
import 'package:p3/pages/storage_file_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Uploader'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   FadeRoute(builder: (context) => FilePickerPage()),
            // );
          },
          child: FilePickerPage(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StoredFilesPage()),
          );
        },
        child: Icon(Icons.list),
      ),
    );
  }
}
