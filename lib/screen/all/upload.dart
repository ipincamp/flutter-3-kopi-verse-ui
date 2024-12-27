import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../../service/config.dart';
import '../../service/storage.dart';

class UploadScreen extends StatefulWidget {
  final String title;
  final String productId;

  const UploadScreen({
    super.key,
    required this.title,
    required this.productId,
  });

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _fileName;
  File? _file;
  bool _uploading = false;
  String? _uploadStatus;

  Future<void> uploadImage() async {
    setState(() {
      _uploading = true;
      _uploadStatus = null;
    });

    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path ?? '');
        _fileName = result.files.single.name;
      });

      final authToken = await Storage.take('auth_token');
      final url = Uri.parse(Config.uploadUrl);
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(Config.headers(token: authToken))
        ..fields['name'] = widget.productId
        ..files.add(await http.MultipartFile.fromPath('file', _file!.path));

      final response = await request.send();
      // final responseBody = await response.stream.bytesToString();
      // print(responseBody);

      setState(() {
        _uploading = false;
        _uploadStatus =
            response.statusCode == 201 ? 'Upload successful' : 'Upload failed';
      });
    } else {
      setState(() {
        _uploading = false;
        _uploadStatus = 'No file selected';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _uploading ? null : uploadImage,
              child:
                  _uploading ? CircularProgressIndicator() : Text('Pick File'),
            ),
            SizedBox(height: 20),
            if (_fileName != null)
              Text(
                'Selected File: $_fileName',
              ),
            SizedBox(height: 20),
            if (_file != null) Image.file(_file!),
            SizedBox(height: 20),
            if (_uploadStatus != null)
              Text(
                _uploadStatus!,
                style: TextStyle(
                  color: _uploadStatus == 'Upload successful'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
