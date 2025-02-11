import 'package:evently_c13/providers/AuthProvider.dart';
import 'package:evently_c13/ui/screens/HomeScreen.dart';
import 'package:evently_c13/ui/screens/setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              authProvider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                SetupScreen.routeName,
                (route) => true,
              );
            },
            child: Text("logout"))
      ],
    );
  }
}
