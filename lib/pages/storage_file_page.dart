import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StoredFilesPage extends StatefulWidget {
  @override
  _StoredFilesPageState createState() => _StoredFilesPageState();
}

class _StoredFilesPageState extends State<StoredFilesPage> {
  List<Reference>? _storedFiles;

  @override
  void initState() {
    super.initState();
    fetchStoredFiles();
  }

  Future<void> fetchStoredFiles() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final storageRef = FirebaseStorage.instance.ref();
      final uploadsRef = storageRef.child("uploads/");
      final uploads = await uploadsRef.listAll();
      setState(() {
        _storedFiles = uploads.items;
      });
    } catch (e) {
      print('Error fetching stored files: $e');
    }
  }

  Future<void> downloadFile(Reference ref) async {
    try {
      final String downloadURL = await ref.getDownloadURL();
      // Implement file download using the downloadURL
      print('File download URL: $downloadURL');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Widget _buildFileTypeIcon(String fileType) {
    IconData iconData;
    switch (fileType) {
      case 'video':
        iconData = Icons.video_library;
        break;
      default:
        iconData = Icons.insert_drive_file;
        break;
    }
    return Icon(iconData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stored Files'),
      ),
      body: _buildFileList(),
    );
  }

  Widget _buildFileList() {
    if (_storedFiles == null || _storedFiles!.isEmpty) {
      return Center(
        child: Text('No files stored yet'),
      );
    }
    return ListView.builder(
      itemCount: _storedFiles!.length,
      itemBuilder: (context, index) {
        Reference ref = _storedFiles![index];
        return ListTile(
          leading: FutureBuilder(
            future: ref.getMetadata(),
            builder: (context, AsyncSnapshot<FullMetadata> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                String fileType =
                    snapshot.data!.contentType?.split('/').first ?? '';
                if (fileType == 'image') {
                  return FutureBuilder(
                    future: FirebaseStorage.instance
                        .ref('thumbnails/${ref.name}')
                        .getDownloadURL(),
                    builder: (context, AsyncSnapshot<String> urlSnapshot) {
                      if (urlSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (urlSnapshot.hasData) {
                        return Image.network(urlSnapshot.data!);
                      } else {
                        return Icon(Icons.error_outline);
                      }
                    },
                  );
                } else {
                  return _buildFileTypeIcon(fileType);
                }
              } else {
                return Icon(Icons.error_outline);
              }
            },
          ),
          title: FutureBuilder(
            future: ref.getMetadata(),
            builder: (context, AsyncSnapshot<FullMetadata> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink();
              } else if (snapshot.hasData) {
                return Text(ref.name);
              } else {
                return Text('Error fetching metadata');
              }
            },
          ),
          onTap: () {
            downloadFile(ref); // Call downloadFile method when tapped
          },
        );
      },
    );
  }
}
