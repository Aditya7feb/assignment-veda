import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:veda/widget/image_input.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        title: Text(
          "Upload Image",
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: ImageInput(),
    );
  }
}
