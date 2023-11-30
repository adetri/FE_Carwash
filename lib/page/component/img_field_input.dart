import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/inc/method.dart';
import 'package:image_picker/image_picker.dart';

class ImageInputField extends StatefulWidget {
  String? base64;
  String? imgUrl;

  ImageInputField({this.base64, this.imgUrl});
  @override
  _ImageInputFieldState createState() => _ImageInputFieldState();
}

class _ImageInputFieldState extends State<ImageInputField> {
  File? _imageFile;
  String? _base64Image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dbg(widget.imgUrl);
  }

  void _updateBase64(String? newBase64) {
    setState(() {
      widget.base64 = 'data:image/png;base64,$newBase64';
    });
  }

  Future<void> _getImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
      _convertImageToBase64(_imageFile!);
    }
  }

  Future<void> _convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    setState(() {
      _base64Image = base64Encode(imageBytes);
      _updateBase64(_base64Image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _getImageFromGallery,
        child: Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: _imageFile != null
                ? Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                  )
                : widget.imgUrl != null
                    ? Image.network(
                        widget.imgUrl ?? "",
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
