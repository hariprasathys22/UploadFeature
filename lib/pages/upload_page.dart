import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadPage extends StatefulWidget {
  final File selectedFile;

  UploadPage({required this.selectedFile});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController _fileNameController = TextEditingController();
  UploadTask? _uploadTask;
  bool _uploadComplete = false;
  String? _uploadedImageUrl;

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  Future<void> _startUpload() async {
    final fileName = _fileNameController.text.isNotEmpty
        ? _fileNameController.text
        : widget.selectedFile.path.split('/').last;
    final destination = 'uploads/$fileName';

    _uploadTask = FirebaseStorage.instance
        .ref()
        .child(destination)
        .putFile(widget.selectedFile);

    try {
      await _uploadTask!;
      setState(() {
        _uploadComplete = true;
      });
      _uploadedImageUrl = await FirebaseStorage.instance
          .ref()
          .child(destination)
          .getDownloadURL();
      print('Uploaded Image URL: $_uploadedImageUrl'); // For debugging
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _fileNameController,
                decoration:
                    InputDecoration(labelText: 'Enter File Name (Optional)'),
              ),
              SizedBox(height: 20),
              Text(
                'Selected File: ${widget.selectedFile.path.split('/').last}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              _uploadComplete
                  ? Column(
                      children: [
                        Image.file(widget.selectedFile,
                            width: 200, height: 200),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                                context); // Navigate back to the previous screen
                          },
                          child: Text('Done'),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: _startUpload,
                      child: Text('Upload File'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
