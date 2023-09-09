import 'package:flutter/material.dart';
import 'package:flutter_blog/constants.dart';

class PostForm extends StatefulWidget {
  const PostForm({super.key});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
      ),
      body: ListView(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.black38,
                ),
              ),
            ),
          ),
          Form(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 9,
                validator: (val) =>
                    val!.isEmpty ? 'Post body is required' : null,
                decoration: const InputDecoration(
                  hintText: 'Post Body...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: kTextButton('POST', () {}),
          ),
        ],
      ),
    );
  }
}
