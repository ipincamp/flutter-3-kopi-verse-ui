import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user.dart';
import '../../service/config.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            onPressed: () {
              userProvider.getUsers();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: userProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: userProvider.users.length,
                    itemBuilder: (context, index) {
                      final user = userProvider.users[index];

                      return ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: const Text('Detail User'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                          '${Config.baseUrl}/assets/${user.image}',
                                        ),
                                      ),
                                      Text(user.name),
                                      Text(user.email),
                                      Text(user.role),
                                      Text(user.joinSince),
                                    ],
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text('Oke'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              '${Config.baseUrl}/assets/${user.image}'),
                        ),
                        title: Text(user.name),
                        trailing: user.role == 'cashier'
                            ? const Icon(Icons.trolley)
                            : const Icon(Icons.monetization_on_outlined),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
