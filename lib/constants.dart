import 'package:flutter/material.dart';

const baseUrl = 'http://192.168.5.10:8080/api';
const loginUrl = '$baseUrl/login';
const registerUrl = '$baseUrl/register';
const logoutUrl = '$baseUrl/logout';
const userUrl = '$baseUrl/user';
const postsUrl = '$baseUrl/posts';
const commentsUrl = '$baseUrl/comments';

// error
const serverError = 'Server Error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again';

// input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    contentPadding: const EdgeInsets.all(10),
    border: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.black),
    ),
  );
}

// button login / register
TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    onPressed: () => onPressed(),
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
      padding: MaterialStateProperty.resolveWith(
        (states) => const EdgeInsets.symmetric(vertical: 10),
      ),
    ),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white),
    ),
  );
}

// login register hint
Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.blue,
          ),
        ),
        onTap: () => onTap(),
      ),
    ],
  );
}

// likes & comments btn
Expanded kLikeAndComment(
    int value, IconData icon, Color color, Function onTap) {
  return Expanded(
    child: Material(
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text('$value'),
            ],
          ),
        ),
      ),
    ),
  );
}
