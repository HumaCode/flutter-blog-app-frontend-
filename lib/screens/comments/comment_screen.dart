import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/constants.dart';
import 'package:flutter_blog/models/api_response.dart';
import 'package:flutter_blog/models/comment.dart';
import 'package:flutter_blog/screens/auth/login.dart';
import 'package:flutter_blog/services/comment_service.dart';
import 'package:flutter_blog/services/user_service.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, this.postId});

  final int? postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<dynamic> commentList = [];
  bool loading = true;
  int userId = 0;
  int editCommentId = 0;
  TextEditingController txtCommentController = TextEditingController();

  // getComment
  Future<void> commentGet() async {
    userId = await getUserId();
    ApiResponse response = await getComments(widget.postId!);

    if (response.error == null) {
      setState(() {
        commentList = response.data as List<dynamic>;
        loading = loading ? !loading : loading;
      });
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

// create comment
  void commentCreate() async {
    ApiResponse response =
        await createComments(widget.postId!, txtCommentController.text);

    if (response.error == null) {
      txtCommentController.clear();
      DInfo.toastSuccess('${response.data}');
      commentGet();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false),
          });
    } else {
      setState(() {
        loading = !loading;
      });
      DInfo.toastError('${response.error}');
    }
  }

  // delete comment
  void commentDelete(int commentId) async {
    ApiResponse response = await deleteComments(commentId);

    if (response.error == null) {
      DInfo.toastSuccess('${response.data}');
      commentGet();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false),
          });
    } else {
      setState(() {
        loading = !loading;
      });
      DInfo.toastError('${response.error}');
    }
  }

  // edit comment
  void commentEdit() async {
    ApiResponse response =
        await editComments(editCommentId, txtCommentController.text);

    if (response.error == null) {
      editCommentId = 0;
      txtCommentController.clear();
      DInfo.toastSuccess('${response.data}');
      commentGet();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false),
          });
    } else {
      setState(() {
        loading = !loading;
      });
      DInfo.toastError('${response.error}');
    }
  }

  @override
  void initState() {
    commentGet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      return commentGet();
                    },
                    child: ListView.builder(
                      itemCount: commentList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Comment comment = commentList[index];

                        return Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black26,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          image: comment.user!.image != null
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                      '${comment.user!.image}'),
                                                  fit: BoxFit.cover)
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${comment.user!.name}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                  comment.user!.id == userId
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
                                                setState(() {
                                                  editCommentId =
                                                      comment.id ?? 0;
                                                  txtCommentController.text =
                                                      comment.comment ?? '';
                                                }),
                                              }
                                            else
                                              {
                                                commentDelete(comment.id!),
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
                              const SizedBox(height: 10),
                              Text('${comment.comment}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.black26,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: kInputDecoration('Comment'),
                          controller: txtCommentController,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (txtCommentController.text.isNotEmpty) {
                            setState(() {
                              loading = true;
                            });
                            if (editCommentId > 0) {
                              commentEdit();
                            } else {
                              commentCreate();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
