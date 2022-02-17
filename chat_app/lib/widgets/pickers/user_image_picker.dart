import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    Key? key,
    required this.pickedImageFunction,
  }) : super(key: key);

  final void Function(File image) pickedImageFunction;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  //funkcja która przechowuje zdjęcie w zmiennej
  void _pickImage() async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 200,
    );
    setState(() {
      _pickedImage = File(image!.path);
    });
    widget.pickedImageFunction(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
        ),
      ],
    );
  }
}
