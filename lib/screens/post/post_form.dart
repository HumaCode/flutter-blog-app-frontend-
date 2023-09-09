import 'package:flutter/material.dart';
import 'package:flutter_blog/constants.dart';

class PostForm extends StatefulWidget {
  const PostForm({super.key});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController textBodyController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
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
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 9,
                      validator: (val) =>
                          val!.isEmpty ? 'Post body is required' : null,
                      controller: textBodyController,
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
                  child: kTextButton('POST', () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        loading = !loading;
                      });
                    }
                  }),
                ),
              ],
            ),
    );
  }
}
