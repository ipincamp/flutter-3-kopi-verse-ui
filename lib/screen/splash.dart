import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kopi_verse/screen/auth/login.dart';
import 'package:kopi_verse/screen/splash/button.dart';
import 'package:kopi_verse/service/config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAPI();
  }

  Future<bool> _checkAPI() async {
    try {
      // Make an API call to the server
      final response = await http.get(Uri.parse(Config.baseUrl));

      if (!mounted) return false;

      // If the API call is successful
      if (response.statusCode == 200) return true;

      return false;
    } catch (e) {
      // If the API call fails
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
                    "Kurang atau Lebih,\nSetiap Rezeki\nPerlu Dirayakan",
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
                    "Dengan Secangkir Kopi",
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
                    future: _checkAPI(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData && snapshot.data == true) {
                        return SizedBox(
                          height: 62,
                          width: size.width * 0.80,
                          child: SplashButton(
                            title: 'Gaskeun!',
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
                            'Gagal nyambung ke server.\nCoba lagi nanti ya.',
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
