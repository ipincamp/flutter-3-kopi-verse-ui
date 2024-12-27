import 'package:flutter/material.dart';
import 'package:kopi_verse/screen/all/login.dart';
import 'package:provider/provider.dart';

import '../../provider/auth.dart';
import '../../provider/user.dart';
import '../../service/config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CustomColors.primaryText;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout().then((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: userProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : userProvider.errorMessage.isNotEmpty
              ? Center(
                  child: Text(userProvider.errorMessage, style: TextStyle(color: textColor)),
                )
              : userProvider.users.isEmpty
                  ? Center(
                      child: Text('No user found', style: TextStyle(color: textColor)),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: userProvider.users.map((user) {
                          return Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.network(
                                      '${Config.baseUrl}/assets/${user.image}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    user.name,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ),
                                Padding(
                                padding: const EdgeInsets.only(
                                  top: 20, left: 16, right: 16),
                                child: SizedBox(
                                  height: 70,
                                  child: Container(
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.transparent : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                    color: isDarkMode ? Colors.white : Colors.transparent,
                                    ),
                                    boxShadow: isDarkMode
                                      ? []
                                      : [
                                        BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                        ),
                                      ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Row(
                                    children: [
                                      const Icon(
                                      Icons.mail_rounded,
                                      color: CustomColors.primaryColor,
                                      size: 28,
                                      ),
                                      Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8, left: 25),
                                        child: Column(
                                        crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                          MainAxisAlignment.start,
                                        children: [
                                          Text(
                                          'Email',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                              FontWeight.normal,
                                            color: textColor,
                                          ),
                                          ),
                                          Padding(
                                          padding:
                                            const EdgeInsets.only(
                                              top: 5),
                                          child: Text(
                                            user.email,
                                            style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                              FontWeight.bold,
                                            color: textColor,
                                            ),
                                          ),
                                          ),
                                        ],
                                        ),
                                      ),
                                      ),
                                    ],
                                    ),
                                  ),
                                  ),
                                ),
                                ),
                                Padding(
                                padding: const EdgeInsets.only(
                                  top: 16, left: 16, right: 16),
                                child: SizedBox(
                                  height: 70,
                                  child: Container(
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.transparent : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                    color: isDarkMode ? Colors.white : Colors.transparent,
                                    ),
                                    boxShadow: isDarkMode
                                      ? []
                                      : [
                                        BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                        ),
                                      ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Row(
                                    children: [
                                      const Icon(
                                      Icons.history,
                                      color: CustomColors.primaryColor,
                                      size: 28,
                                      ),
                                      Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8, left: 25),
                                        child: Column(
                                        crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                          MainAxisAlignment.start,
                                        children: [
                                          Text(
                                          'Join Since',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                              FontWeight.normal,
                                            color: textColor,
                                          ),
                                          ),
                                          Padding(
                                          padding:
                                            const EdgeInsets.only(
                                              top: 5),
                                          child: Text(
                                            user.joinSince,
                                            style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                              FontWeight.bold,
                                            color: textColor,
                                            ),
                                          ),
                                          ),
                                        ],
                                        ),
                                      ),
                                      ),
                                    ],
                                    ),
                                  ),
                                  ),
                                ),
                                ),
                                Padding(
                                padding: const EdgeInsets.only(
                                  top: 16, left: 16, right: 16),
                                child: SizedBox(
                                  height: 70,
                                  child: Container(
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.transparent : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                    color: isDarkMode ? Colors.white : Colors.transparent,
                                    ),
                                    boxShadow: isDarkMode
                                      ? []
                                      : [
                                        BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                        ),
                                      ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Row(
                                    children: [
                                      const Icon(
                                      Icons.lock,
                                      color: CustomColors.primaryColor,
                                      size: 28,
                                      ),
                                      Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8, left: 25),
                                        child: Column(
                                        crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                          MainAxisAlignment.start,
                                        children: [
                                          Text(
                                          'Role',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                              FontWeight.normal,
                                            color: textColor,
                                          ),
                                          ),
                                          Padding(
                                          padding:
                                            const EdgeInsets.only(
                                              top: 5),
                                          child: Text(
                                            user.role,
                                            style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                              FontWeight.bold,
                                            color: textColor,
                                            ),
                                          ),
                                          ),
                                        ],
                                        ),
                                      ),
                                      ),
                                    ],
                                    ),
                                  ),
                                  ),
                                ),
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
    );
  }
}

class CustomColors {
  static const Color primaryColor = Color(0xFF7D5A50);
  static const Color secondaryColor = Color(0xFFFDF6F0);
  static const Color primaryText = Color(0xFF000000);
}
