import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kopi_verse/screen/auth/login.dart';
import 'package:kopi_verse/service/auth.dart';
import 'package:kopi_verse/service/storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<String?> _userRoleFuture;

  @override
  void initState() {
    super.initState();
    _userRoleFuture = _loadUserRole();
  }

  Future<String?> _loadUserRole() async {
    try {
      return await Storage.take('auth_role');
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<String?>(
        future: _userRoleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Error loading user role');
          } else {
            final role = snapshot.data ?? 'Guest';

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'You login as $role',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final response = await AuthService.logout();
                    final responseJson = jsonDecode(response.body);

                    if (response.statusCode == 202) {
                      await Storage.drop('auth_token');
                      await Storage.drop('auth_role');

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(responseJson['message']),
                        ),
                      );
                    }
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
