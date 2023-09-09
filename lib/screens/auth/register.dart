import 'package:flutter/material.dart';
import 'package:flutter_blog/constants.dart';
import 'package:flutter_blog/models/api_response.dart';
import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/screens/auth/login.dart';
import 'package:flutter_blog/screens/home.dart';
import 'package:flutter_blog/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  bool loading = false;

// fungsi register
  void _registerUser() async {
    ApiResponse response = await register(
        nameController.text,
        emailController.text,
        passwordController.text,
        passwordConfirmationController.text);

    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REGISTER'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: nameController,
              validator: (val) => val!.isEmpty ? 'Name required' : null,
              decoration: kInputDecoration('Name'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: (val) => val!.isEmpty ? 'Email required' : null,
              decoration: kInputDecoration('Email'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              validator: (val) => val!.isEmpty ? 'Password required' : null,
              decoration: kInputDecoration('Password'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              controller: passwordConfirmationController,
              validator: (val) => val != passwordController.text
                  ? 'Password confirmation does not match..'
                  : null,
              decoration: kInputDecoration('Password Confirmation'),
            ),
            const SizedBox(height: 10),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : kTextButton('REGISTER', () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        _registerUser();
                      });
                    }
                  }),
            const SizedBox(height: 10),
            kLoginRegisterHint('Already have an account.?', ' login', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            })
          ],
        ),
      ),
    );
  }
}
