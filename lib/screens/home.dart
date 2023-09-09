import 'package:flutter/material.dart';
import 'package:flutter_blog/screens/auth/login.dart';
import 'package:flutter_blog/services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          logout().then((value) => {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false)
              });
        },
        child: const Center(
          child: Text('HOME'),
        ),
      ),
    );
  }
}
