import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './login.dart';
import '../../common/text_util.dart';
import '../../provider/auth.dart';
import '../../screen/all/home.dart';
import '../../service/config.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // fungsi handle register
  void _handleRegister(BuildContext context) async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password and Confirm Password must be the same"),
        ),
      );
      return;
    }

    // connect with api using AuthProvider
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.register(
        name,
        email,
        password,
        confirmPassword,
      );

      if (response) {
        final authRole = authProvider.role;

        // navigate to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(role: authRole),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Register failed!"),
        ),
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
            image: AssetImage(Config.bgList[1]),
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
                      /** Full Name */
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
                      /** Email */
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
                      /** Password */
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
                      /** Confirm Password */
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
                      /** Action Button */
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
                      /** Login Link */
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
