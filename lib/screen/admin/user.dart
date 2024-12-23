import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth.dart';

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
      Provider.of<AuthProvider>(context, listen: false).getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
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
                      print(user);

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.image),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.email),
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
