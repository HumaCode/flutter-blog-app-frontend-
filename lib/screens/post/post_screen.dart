import 'package:flutter/material.dart';
import 'package:flutter_blog/constants.dart';
import 'package:flutter_blog/models/api_response.dart';
import 'package:flutter_blog/models/post.dart';
import 'package:flutter_blog/screens/auth/login.dart';
import 'package:flutter_blog/services/post_services.dart';
import 'package:flutter_blog/services/user_service.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> postList = [];
  int userId = 0;
  bool loading = true;

  // get all post
  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPost();

    if (response.error == null) {
      setState(() {
        postList = response.data as List<dynamic>;
        loading = loading ? !loading : loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  // post like dislike
  void handlePostLikeDislike(int postId) async {
    ApiResponse response = await likeUnlikePost(postId);

    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: () {
              return retrievePosts();
            },
            child: ListView.builder(
                itemCount: postList.length,
                itemBuilder: (BuildContext context, int index) {
                  Post post = postList[index];

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      image: post.user!.image != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                '${post.user!.image}',
                                              ),
                                            )
                                          : null,
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${post.user!.name}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            post.user!.id == userId
                                ? PopupMenuButton(
                                    itemBuilder: (contex) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                    onSelected: (val) => {
                                      if (val == 'edit')
                                        {
                                          // edit
                                        }
                                      else
                                        {
                                          // delete
                                        }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('${post.body}'),
                        post.image != null
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 180,
                                margin: const EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage('${post.image}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : SizedBox(height: post.image != null ? 0 : 10),
                        Row(
                          children: [
                            kLikeAndComment(
                              post.likesCount ?? 0,
                              post.selfLiked == true
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              post.selfLiked == true
                                  ? Colors.red
                                  : Colors.black38,
                              () {
                                handlePostLikeDislike(post.id!);
                              },
                            ),
                            Container(
                              height: 25,
                              width: 0.5,
                              color: Colors.black38,
                            ),
                            kLikeAndComment(
                              post.commentsCount ?? 0,
                              Icons.sms_outlined,
                              Colors.black38,
                              () {},
                            ),
                          ],
                        ),
                        Container(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  );
                }),
          );
  }
}
