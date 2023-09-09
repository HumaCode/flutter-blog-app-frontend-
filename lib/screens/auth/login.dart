import 'package:flutter/material.dart';
import 'package:flutter_blog/constants.dart';
import 'package:flutter_blog/models/api_response.dart';
import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/screens/auth/register.dart';
import 'package:flutter_blog/screens/home.dart';
import 'package:flutter_blog/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  // fungsi login
  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);

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
        title: const Text('LOGIN'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
              validator: (val) => val!.isEmpty ? 'Email required' : null,
              decoration: kInputDecoration('Email'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              controller: txtPassword,
              validator: (val) => val!.isEmpty ? 'Password required' : null,
              decoration: kInputDecoration('Password'),
            ),
            const SizedBox(height: 10),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : kTextButton('LOGIN', () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        _loginUser();
                      });
                    }
                  }),
            const SizedBox(height: 10),
            kLoginRegisterHint('Dont have an account.?', ' Register', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                  (route) => false);
            })
          ],
        ),
      ),
    );
  }
}
