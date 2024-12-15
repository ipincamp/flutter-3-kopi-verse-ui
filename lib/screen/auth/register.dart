import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kopi_verse/screen/auth/login.dart';
import 'package:kopi_verse/screen/home.dart';
import 'package:kopi_verse/service/auth.dart';
import 'package:kopi_verse/service/storage.dart';

import './data/bg_data.dart';
import './utils/text_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  int selectedIndex = 0;
  bool showOption = false;

  @override
  void initState() {
    super.initState();
    _startBackgroundChange();
  }

  void _startBackgroundChange() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          selectedIndex = (selectedIndex + 1) % bgList.length;
        });
        _startBackgroundChange();
      }
    });
  }

  void _handleRegister(BuildContext context) async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // attempt to register with AuthService
    final response = await AuthService.register(name, email, password, confirmPassword);
    final json = jsonDecode(response.body);

    if (response.statusCode == 201) {
      // register successful
      await Storage.save('auth_token', json['data']['token']);
      await Storage.save('auth_role', 'customer');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      // register failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Icon(
              Icons.error,
              color: Colors.red,
              size: 40,
            ),
            content: Text(json['errors']),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgList[selectedIndex]),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          height: 550,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Center(
                          child: TextUtil(
                        text: "Register",
                        weight: true,
                        size: 30,
                      )),
                      const Spacer(),
                      // name input
                      TextUtil(
                        text: "Full Name",
                      ),
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white),
                          ),
                        ),
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText: 'Enter your name',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // email input
                      TextUtil(
                        text: "Email",
                      ),
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white),
                          ),
                        ),
                        child: TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.mail,
                              color: Colors.white,
                            ),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // password input
                      TextUtil(
                        text: "Password",
                      ),
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white),
                          ),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText: 'Enter your password',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // confirmation_password input
                      TextUtil(
                        text: "Confirm Password",
                      ),
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white),
                          ),
                        ),
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText: 'Confirm your password',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // register button
                      ElevatedButton(
                        onPressed: () => _handleRegister(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffC67C4E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size(double.infinity, 40),
                        ),
                        child: TextUtil(
                          text: "Register",
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      // login
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: TextUtil(
                            text: "Already have an account?",
                            size: 12,
                            weight: true,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
