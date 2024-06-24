import 'dart:io';
import 'package:codexia_academys/services/database_service.dart';
import 'package:codexia_academys/services/validator_Services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/model.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController feesController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController joinDateController = TextEditingController();
  TextEditingController pendingFeeController = TextEditingController();
  TextEditingController paidFeeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();
  File? image;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        joinDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ImagePickWidget(
                  onImagePicked: (pickedImage) {
                    setState(() {
                      image = pickedImage;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: validatorService,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: fNameController,
                  decoration: const InputDecoration(
                    labelText: 'Father Name',
                  ),
                  validator: validatorService,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: villageController,
                  decoration: const InputDecoration(
                    labelText: 'Village',
                  ),
                  validator: validatorService,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: joinDateController,
                  decoration: InputDecoration(
                    labelText: 'Join Date',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  validator: validatorService,
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: feesController,
                  decoration: const InputDecoration(
                    labelText: 'Total Fees',
                  ),
                  validator: validatorService,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: pendingFeeController,
                  decoration: const InputDecoration(
                    labelText: 'Pending Fees',
                  ),
                  validator: validatorService,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: paidFeeController,
                  decoration: const InputDecoration(
                    labelText: 'Pay Fees',
                  ),
                  validator: validatorService,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      StudentModel newStudent = StudentModel(
                        name: nameController.text,
                        fName: fNameController.text,
                        village: villageController.text,
                        fees: feesController.text,
                        image: image?.path ?? '',
                        joinDate: joinDateController.text,
                        pendingFee: pendingFeeController.text,
                        paidFee: paidFeeController.text,
                      );
                      DatabaseService databaseService = DatabaseService();
                      await databaseService.insertStudent(newStudent);
                      Navigator.pop(context,
                          true);
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
