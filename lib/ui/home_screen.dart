import 'dart:io';
import 'package:codexia_academys/services/database_service.dart';
import 'package:codexia_academys/ui/add_student_screen.dart';
import 'package:codexia_academys/ui/update_screen.dart';
import 'package:flutter/material.dart';

import '../model/model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<StudentModel> students = [];
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    loadStudent();
  }

  Future<void> loadStudent() async {
    students = await DatabaseService.fetchStudents();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddStudentScreen(),
            ),
          );
          if (result == true) {
            loadStudent();
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
      body: students.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                StudentModel std = students[index];
                return Card(
                  elevation: 8,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (std.image.isNotEmpty &&
                            File(std.image).existsSync())
                          Image.file(
                            File(std.image),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(
                          height: 16,
                        ),
                        studentRecord('Name', std.name),
                        const SizedBox(height: 8),
                        studentRecord('Father Name', std.fName),
                        const SizedBox(height: 8),
                        studentRecord('Village', std.village),
                        const SizedBox(height: 8),
                        studentRecord('Joining Date', std.joinDate),
                        const SizedBox(height: 8),
                        studentRecord('Pending Fees', std.pendingFee),
                        const SizedBox(height: 8),
                        studentRecord('Paid Fees', std.paidFee),
                        const SizedBox(height: 8),
                        studentRecord('Total Fees', std.fees),
                        const SizedBox(
                          height: 4,
                        ),
                        Divider(
                          color: Colors.grey.shade100,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return UpdateStudentScreen(student: std);
                                  }));
                                  loadStudent();
                                },
                                icon: const Icon(Icons.edit)),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Delete Student'),
                                      content: const Text(
                                          'Are you sure you want to delete this student?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await DatabaseService.deleteStudent(
                                                std.id!);
                                            loadStudent();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget studentRecord(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
