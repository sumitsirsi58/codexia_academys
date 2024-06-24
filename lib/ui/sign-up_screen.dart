import 'dart:async';
import 'package:codexia_academys/const/color_const.dart';
import 'package:codexia_academys/services/validator_Services.dart';
import 'package:codexia_academys/ui/home_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool _obscureText = true;
  Timer? _timer;

  void _showPassword() {
    setState(() {
      _obscureText = false;
    });
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        _obscureText = true;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Codexia',
                      style: TextStyle(
                        color: ColorConst.timeText,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Academy',
                      style: TextStyle(
                        color: ColorConst.newsText,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 26,
                ),
                TextFormField(
                  cursorColor: Colors.grey,
                  controller: nameController,
                  decoration: InputDecoration(
                      label: const Text(
                        'Name',
                        style: TextStyle(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ))),
                  validator: validatorService,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  cursorColor: Colors.grey,
                  controller: emailController,
                  decoration: InputDecoration(
                      label: const Text(
                        'Email',
                        style: TextStyle(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Colors.grey)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.grey),
                      )),
                  validator: validatorService,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  cursorColor: Colors.grey,
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                      label: const Text(
                        'Password',
                        style: TextStyle(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Colors.grey)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: _showPassword,
                        child: const Icon(
                          Icons.visibility,
                          color: Colors.grey,
                        ),
                      )),
                  validator: validatorService,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConst.buttonColor),
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) ;
                    },
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ));
                      },
                      child: const Text(
                        'SignUp',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    const SizedBox(
                      width: 4,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'LogIn',
                          style: TextStyle(color: ColorConst.timeText),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
