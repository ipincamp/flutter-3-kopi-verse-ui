import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../../service/config.dart';

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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _file = File(result.files.single.path!);
      });
    }

    // TODO: upload to server via http
    final url = Config.uploadUrl;
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        await _file!.readAsBytes(),
        filename: _fileName!,
      ),
    );

    request.fields['productId'] = widget.productId;

    final response = await request.send();
    if (response.statusCode == 200) {
      print('Uploaded');
    } else {
      print('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pick File'),
            ),
            SizedBox(height: 20),
            Text(
              _fileName != null
                  ? 'Selected File: $_fileName'
                  : 'No file selected',
            ),
            SizedBox(height: 20),
            _file != null ? Image.file(_file!) : Container(),
          ],
        ),
      ),
    );
  }
}
