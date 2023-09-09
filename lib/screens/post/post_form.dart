import 'dart:io';
import 'package:flutter_blog/models/api_response.dart';
import 'package:flutter_blog/screens/auth/login.dart';
import 'package:flutter_blog/services/post_services.dart';
import 'package:flutter_blog/services/user_service.dart';
import 'package:image_picker/image_picker.dart';
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

  File? imageFile;
  final picker = ImagePicker();

  // fungsi image picker
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // fungsi create post
  void postCreate() async {
    String? image = imageFile == null ? null : getStringImage(imageFile);

    ApiResponse response = await createPost(textBodyController.text, image);

    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false),
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$response.error'),
          dismissDirection: DismissDirection.up,
        ),
      );
      setState(() {
        loading = !loading;
      });
    }
  }

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
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    image: imageFile == null
                        ? null
                        : DecorationImage(
                            image: FileImage(
                              imageFile ?? File(''),
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        getImage();
                      },
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
                      postCreate();
                    }
                  }),
                ),
              ],
            ),
    );
  }
}
