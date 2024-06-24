import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codexia_academys/const/color_const.dart';
import 'package:codexia_academys/services/validator_Services.dart';
import 'package:codexia_academys/ui/home_screen.dart';
import 'package:codexia_academys/ui/sign-up_screen.dart';
import 'package:codexia_academys/services/database_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool _obscureText = true;
  Timer? _timer;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    DatabaseService databaseService = DatabaseService();
    bool isLoggedIn = await databaseService.isUserExists('isLoggedIn');
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _login() async {
    if (formKey.currentState?.validate() ?? false) {
      DatabaseService databaseService = DatabaseService();
      bool isLogin = await databaseService.login(
          emailController.text, passwordController.text);
      if (isLogin && mounted) {
        await databaseService.login(
            emailController.text, passwordController.text);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        print('Invalid email or password');
      }
    }
  }

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var login;
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
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey),
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
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey),
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
                    onPressed: login,
                    child: const Text(
                      'LogIn',
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    const SizedBox(
                      width: 4,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ));
                        },
                        child: const Text(
                          'SignUp',
                          style: TextStyle(color: ColorConst.timeText),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
