import 'dart:io';

import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/constants.dart';
import 'package:flutter_blog/models/api_response.dart';
import 'package:flutter_blog/models/user.dart';
import 'package:flutter_blog/screens/auth/login.dart';
import 'package:flutter_blog/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? imageFile;
  final picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();

  // fungsi image picker
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // getUser detail
  void getUser() async {
    ApiResponse response = await getUserDetail();

    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
                (route) => false),
          });
    } else {
      DInfo.toastError('${response.error}');
    }
  }

  // update profile
  void updateProfil() async {
    ApiResponse response =
        await updateUser(txtNameController.text, getStringImage(imageFile));

    setState(() {
      loading = false;
    });

    if (response.error == null) {
      DInfo.toastSuccess('${response.data}');
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false),
          });
    } else {
      DInfo.toastError('${response.error}');
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        image: imageFile == null
                            ? user!.image != null
                                ? DecorationImage(
                                    image: NetworkImage('${user!.image}'),
                                    fit: BoxFit.cover)
                                : null
                            : DecorationImage(
                                image: FileImage(
                                  imageFile ?? File(''),
                                ),
                                fit: BoxFit.cover,
                              ),
                        color: Colors.amber,
                      ),
                    ),
                    onTap: () {
                      getImage();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: kInputDecoration('Name'),
                    controller: txtNameController,
                    validator: (val) =>
                        val!.isEmpty ? 'Name is required..!' : null,
                  ),
                ),
                const SizedBox(height: 20),
                kTextButton('UPDATE', () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });

                    updateProfil();
                  }
                })
              ],
            ),
          );
  }
}
