import 'package:abccompany/components/sidedrawer.dart';
import 'package:abccompany/models/postModel.dart';
import 'package:abccompany/screens/home/newPost.dart';
import 'package:abccompany/services/posts.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PostScreenState();
  }
}

class PostScreenState extends State<PostScreen> {
  bool _isLoading = false;
  List posts = [];
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  initState() {
    fetchPosts();
    super.initState();
  }

  fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    var response = await PostService.fetchPosts();
    setState(() {
      _isLoading = false;
    });
    print('response $response');
    posts = response['data'];
  }

  deletePost(postId) async {
    setState(() {
      _isLoading = true;
    });

    var response = await PostService.deletePost(postId);
    setState(() {
      _isLoading = false;
    });
    print('response $response');
    if (response == true) {
      showSnackbar('Post Deleted');
      new Future.delayed(const Duration(seconds: 2), () => fetchPosts());
    } else {
      showSnackbar('Unable to delete post');
    }
  }

  showSnackbar(message) {
    final _snackBar = SnackBar(content: Text('$message'));
    _drawerKey.currentState!.showSnackBar(_snackBar);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _drawerKey,
        appBar: AppBar(
          leading: InkWell(
              onTap: () => _drawerKey.currentState!.openDrawer(),
              child: Icon(Icons.menu)),
          title: Text('My Posts'),
          actions: [
            FlatButton(
                onPressed: () {
                  fetchPosts();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewPost()));
                },
                child: Text('Create a Post',
                    style: TextStyle(color: Colors.white)))
          ],
        ),
        drawer: SideDrawer(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : posts.length == 0
                ? Center(child: Text('You have not made any post yet'))
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: ((BuildContext context, index) {
                      var post = posts[index];
                      return ListTile(
                        leading: CircleAvatar(),
                        title: Text('${post.title}'),
                        subtitle: Text('${post.description}'),
                        trailing: GestureDetector(
                            onTap: () {
                              deletePost(post.id);
                            },
                            child: Icon(Icons.delete_forever,
                                color: Colors.red, size: 17)),
                      );
                    }),
                  ));
  }
}
