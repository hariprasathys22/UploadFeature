import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:p3/pages/upload_page.dart';

class FilePickerPage extends StatefulWidget {
  @override
  _FilePickerPageState createState() => _FilePickerPageState();
}

class _FilePickerPageState extends State<FilePickerPage> {
  File? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null) {
      var file = File(result.files.single.path!);
      if (file.lengthSync() > 10 * 1024 * 1024) {
        // File size exceeds 10 MB
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected file exceeds 10 MB')),
        );
      } else {
        setState(() {
          _selectedFile = file;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadPage(selectedFile: _selectedFile!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _pickFile,
          child: Text('Select File'),
        ),
      ),
    );
  }
}
