import 'package:codexia_academys/model/model.dart';
import 'package:codexia_academys/services/database_service.dart';
import 'package:codexia_academys/services/validator_services.dart';
import 'package:flutter/material.dart';

class UpdateStudentScreen extends StatefulWidget {
  final StudentModel student;

  UpdateStudentScreen({required this.student});

  @override
  _UpdateStudentScreenState createState() => _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController feesController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController joinDateController = TextEditingController();
  TextEditingController pendingFeeController = TextEditingController();
  TextEditingController paidFeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.student.name;
    fNameController.text = widget.student.fName;
    villageController.text = widget.student.village;
    feesController.text = widget.student.fees;
    imageController.text = widget.student.image;
    joinDateController.text = widget.student.joinDate;
    pendingFeeController.text = widget.student.pendingFee;
    paidFeeController.text = widget.student.paidFee;
  }

  final GlobalKey<FormState> formKey = GlobalKey();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                  ),
                  validator: validatorService,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: fNameController,
                  decoration: const InputDecoration(
                    label: Text('Father Name'),
                  ),
                  validator: validatorService,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: villageController,
                  decoration: const InputDecoration(
                    label: Text('Village'),
                  ),
                  validator: validatorService,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: feesController,
                  decoration: const InputDecoration(
                    label: Text('Total Fees'),
                  ),
                  validator: validatorService,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: joinDateController,
                  decoration: InputDecoration(
                    label: const Text('Join Date'),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  validator: validatorService,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: pendingFeeController,
                  decoration: const InputDecoration(
                    label: Text('Pending Fees'),
                  ),
                  validator: validatorService,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: paidFeeController,
                  decoration: const InputDecoration(
                    label: Text('Paid Fees'),
                  ),
                  validator: validatorService,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      StudentModel updateStudent = StudentModel(
                        id: widget.student.id,
                        name: nameController.text,
                        fName: fNameController.text,
                        village: villageController.text,
                        fees: feesController.text,
                        image: imageController.text,
                        joinDate: joinDateController.text,
                        pendingFee: pendingFeeController.text,
                        paidFee: paidFeeController.text,
                      );
                      await DatabaseService().updateStudent(updateStudent);
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text(
                    'Update',
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
