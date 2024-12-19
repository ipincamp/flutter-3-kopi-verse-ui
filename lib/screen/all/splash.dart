import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import './login.dart';
import '../../service/config.dart';
import '../../common/splash_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _serverCheck();
  }

  Future<bool> _serverCheck() async {
    try {
      final response = await http.get(Uri.parse(Config.baseUrl));
      if (!mounted) return false;
      if (response.statusCode == 200) return true;
      return true;
    } catch (e) {
      if (!mounted) return false;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: size.height * 0.68,
              width: size.width,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/welcome.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Celebrate\nEvery Blessing",
                    style: GoogleFonts.sora(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.010,
                  ),
                  Text(
                    "With a Cup of Coffee",
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFA9A9A9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.030,
                  ),
                  FutureBuilder<bool>(
                    future: _serverCheck(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData && snapshot.data == true) {
                        return SizedBox(
                          height: 62,
                          width: size.width * 0.80,
                          child: SplashButton(
                            title: 'Get Started',
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        Future.delayed(const Duration(seconds: 3), () {
                          setState(() {});
                        });

                        return const Text(
                          'Failed to connect to the server.\nPlease try again later.',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.030,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}