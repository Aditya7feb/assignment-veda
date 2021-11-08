import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as state;

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({Key? key}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  bool upload = false;
  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    setState(() {
      _storedImage = File(imageFile!.path);
    });
  }

  Future<bool> _upload() async {
    final file = _storedImage!;
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    Dio dio = new Dio();

    await dio
        .post("https://codelime.in/api/remind-app-token", data: data)
        .then((response) {
      print(response);
      setState(() {
        upload = true;
      });
    }).catchError((error) {
      throw error;
    });
    return upload;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        _storedImage != null
            ? Container(
                height: deviceSize.height * 0.4,
                width: deviceSize.width * 0.9,
                decoration: BoxDecoration(
                  //border: Border.all(color: uPrimaryColor),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[100],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.20),
                      offset: Offset(-3, -3),
                      blurRadius: 6.0,
                      spreadRadius: 0.8,
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.35),
                      //Colors.grey.shade500,
                      offset: Offset(3, 3),
                      blurRadius: 6.0,
                      spreadRadius: 0.8,
                    ),
                  ],
                ),
                child: Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Container(),
        SizedBox(
          height: 50,
        ),
        if (_storedImage == null)
          Center(
              child: TextButton.icon(
                  onPressed: _takePicture,
                  icon: Icon(Icons.camera),
                  label: Text("Choose Image"))),
        if (_storedImage != null)
          Center(
              child: !upload
                  ? TextButton.icon(
                      onPressed: () async {
                        try {
                          bool response = await _upload();
                          if (response) {
                            state.Get.snackbar(
                                "Image Uploaded Successfully", "",
                                backgroundColor: Colors.green);
                          }
                        } catch (e) {
                          state.Get.snackbar("Some error occured", "");
                        }
                      },
                      icon: Icon(Icons.cloud_upload_outlined),
                      label: Text("Upload Image"))
                  : Text(
                      "Upload Sucessfull..!!",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    )),
      ],
    );
  }
}
