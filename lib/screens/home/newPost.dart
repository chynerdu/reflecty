import 'package:abccompany/components/firstButton.dart';
import 'package:abccompany/screens/home/posts.dart';
import 'package:abccompany/services/posts.dart';
import 'package:flutter/material.dart';

class NewPost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewPostState();
  }
}

class NewPostState extends State<NewPost> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'image': null
  };
  bool _isLoading = false;

  void next() async {
    if (!_formKey.currentState!.validate()) {
      print('validation failed');
      return;
    }
    print('validated');
    setState(() {
      _isLoading = true;
    });

    submit();
  }

  submit() async {
    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();
    var response = await PostService.publishPost(
        title: _formData['title'],
        description: _formData['description'],
        image: 'false');
    setState(() {
      _isLoading = false;
    });
    print('response $response');
    if (response == true) {
      showSnackbar('Post successfully published');
      new Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => PostScreen())));
    } else {
      showSnackbar('Unable to publish post');
    }
  }

  showSnackbar(message) {
    final _snackBar = SnackBar(content: Text('$message'));
    _scaffoldKey.currentState!.showSnackBar(_snackBar);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('New Post'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(color: Colors.white)))
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Text('Enter a title and description'),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(
                              // color: Colors.black,
                              ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(25, 20, 20, 20),
                            labelText: 'Title',
                            hintStyle: TextStyle(color: Colors.black),
                            isDense: true,
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          onSaved: (value) {
                            _formData['title'] = value;
                          },
                        ),
                        SizedBox(height: 40),
                        TextFormField(
                          maxLines: 3,
                          style: TextStyle(

                              // color: Colors.black,
                              ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(25, 20, 20, 20),
                            labelText: 'Description',
                            hintStyle: TextStyle(color: Colors.black),
                            isDense: true,
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          onSaved: (value) {
                            _formData['description'] = value;
                          },
                        ),
                        SizedBox(height: 65),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : FirstButton(next, 'Publish Post'),
                        SizedBox(height: 20),
                      ],
                    )))));
  }
}
