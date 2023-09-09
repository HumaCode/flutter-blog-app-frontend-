import 'dart:convert';
import 'dart:io';
import 'package:d_info/d_info.dart';
import 'package:flutter_blog/models/api_response.dart';
import 'package:flutter_blog/models/post.dart';
import 'package:flutter_blog/screens/auth/login.dart';
import 'package:flutter_blog/services/post_services.dart';
import 'package:flutter_blog/services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/constants.dart';

class PostForm extends StatefulWidget {
  const PostForm({super.key, this.post, this.title});

  final Post? post;
  final String? title;

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
      DInfo.toastSuccess('${response.data}');

      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false),
          });
    } else {
      DInfo.toastError('${response.error}');

      setState(() {
        loading = !loading;
      });
    }
  }

  // fungsi edit post
  void postEdit(int postId) async {
    String? image = imageFile == null ? null : getStringImage(imageFile);

    ApiResponse response =
        await editPost(postId, textBodyController.text, image);

    if (response.error == null) {
      DInfo.toastSuccess('${response.data}');
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false),
          });
    } else {
      DInfo.toastError('${response.error}');
      setState(() {
        loading = !loading;
      });
    }
  }

  @override
  void initState() {
    if (widget.post != null) {
      textBodyController.text = widget.post!.body!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
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
                    image: (imageFile != null)
                        ? DecorationImage(
                            image: FileImage(
                              imageFile!,
                            ),
                            fit: BoxFit.cover,
                          )
                        : (widget.post != null && widget.post!.image != null)
                            ? DecorationImage(
                                image: NetworkImage(
                                  widget.post!.image!,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
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

                      if (widget.post == null) {
                        postCreate();
                      } else {
                        postEdit(widget.post!.id!);
                      }
                    }
                  }),
                ),
              ],
            ),
    );
  }
}
