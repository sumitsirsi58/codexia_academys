import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickWidget extends StatefulWidget {
  final Function(File) onImagePicked;

  const ImagePickWidget({super.key, required this.onImagePicked});

  @override
  _ImagePickWidgetState createState() => _ImagePickWidgetState();
}

class _ImagePickWidgetState extends State<ImagePickWidget> {
  File? _pickedImage;

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
      widget.onImagePicked(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => _pickImage(context),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            backgroundImage:
            _pickedImage != null ? FileImage(_pickedImage!) : null,
            child: _pickedImage == null
                ? const Icon(
              Icons.camera_alt,
              size: 50,
              color: Colors.grey,
            )
                : null,
          ),
        ),
        if (_pickedImage != null) const SizedBox(height: 10),
        if (_pickedImage != null)
          const Text('Tap to change image',
              style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}