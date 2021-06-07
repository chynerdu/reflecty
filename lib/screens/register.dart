import 'dart:convert';

import 'package:abccompany/components/firstButton.dart';
import 'package:abccompany/constants/styles.dart';
import 'package:abccompany/screens/home/posts.dart';
import 'package:abccompany/screens/login.dart';
import 'package:abccompany/services/auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register> {
  dynamic selectedValue;
  IconData textVisibility = Icons.visibility_off;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool hideText = true;
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, dynamic> _formData = {
    'password': null,
    'email': null,
    'firstName': null,
    'surname': null
  };

  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = false;
    });

    super.initState();
  }

  void next() async {
    if (!_formKey.currentState!.validate()) {
      print('validation failed');
      return;
    }
    print('validated');
    setState(() {
      isLoading = true;
    });

    register();
  }

  register() async {
    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();
    var response = await Auth.signupService(
      surname: _formData['surname'],
      firstName: _formData['firstName'],
      email: _formData['email'],
      password: _formData['password'],
    );
    setState(() {
      _isLoading = false;
    });
    print('response $response');
    if (response['success'] == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => PostScreen())));
    } else {
      showSnackbar(response['message']);
    }
  }

  showSnackbar(message) {
    final _snackBar = SnackBar(content: Text('$message'));
    _scaffoldKey.currentState!.showSnackBar(_snackBar);
  }

  showExitAppDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Exit App"),
            content: Text('Are you sure you want to exit the application?'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No',
                    style: TextStyle(
                      color: Color(0xff0047ff),
                    )),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  SystemNavigator.pop();
                },
                child: Text('Yes'),
              )
            ],
          );
        });
  }

  // build Intro
  Widget buildIntro() {
    return Container(
        padding: EdgeInsets.only(bottom: 30, left: 20, right: 20),
        child: Column(
          children: <Widget>[
            Text('Create an Account', style: Styles.headerStyle),
            SizedBox(height: 10),
            Text('Create your account by submitting your basic information',
                textAlign: TextAlign.center, style: Styles.subHeaderStyle),
            SizedBox(height: 10),
          ],
        ));
  }

  changeVisibility() {
    print('pressed');
    if (textVisibility == Icons.visibility_off) {
      setState(() {
        textVisibility = Icons.visibility;
        hideText = false;
      });
    } else {
      setState(() {
        textVisibility = Icons.visibility_off;
        hideText = true;
      });
    }
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  buildContent() {
    return Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 40),
                  TextFormField(
                    style: TextStyle(),
                    decoration: InputDecoration(
                        labelText: 'Surname',
                        contentPadding: EdgeInsets.only(
                          bottom: 4,
                        ), //  <- you can it to 0.0 for no space

                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        )),
                    onSaved: (value) {
                      _formData['surname'] = value;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    style: TextStyle(),
                    decoration: InputDecoration(
                        labelText: 'First Name',
                        contentPadding: EdgeInsets.only(
                          bottom: 4,
                        ), //  <- you can it to 0.0 for no space

                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        )),
                    onSaved: (value) {
                      _formData['firstName'] = value;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    style: TextStyle(
                        // color: Colors.black,
                        ),
                    decoration: InputDecoration(
                        labelText: 'Enter your email',
                        contentPadding: EdgeInsets.only(
                          bottom: 4,
                        ), //  <- you can it to 0.0 for no space

                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        )),
                    onSaved: (value) {
                      _formData['email'] = value;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: hideText,
                    style: TextStyle(
                        // color: Colors.black,
                        ),
                    decoration: InputDecoration(
                        suffix: InkWell(
                            child: Icon(textVisibility, size: 22),
                            onTap: () {
                              changeVisibility();

                              rebuildAllChildren(context);
                            }),
                        labelText: 'Password',
                        contentPadding: EdgeInsets.only(
                          bottom: 4,
                        ), //  <- you can it to 0.0 for no space

                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        )),
                    onSaved: (value) {
                      _formData['password'] = value;
                    },
                  ),
                  SizedBox(height: 65),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : FirstButton(next, 'Sign up')
                ])));
  }

  Widget buildBody() {
    return Column(
      children: <Widget>[buildIntro(), SizedBox(height: 20), buildContent()],
    );
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => showExitAppDialog(),
        child: SafeArea(
            child: Scaffold(
          key: _scaffoldKey,
          body: Column(
            children: <Widget>[
              Flexible(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 120),
                    Container(
                        child: Column(
                      children: <Widget>[Container(child: buildBody())],
                    )),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 30, left: 20, right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account?"),
                        InkWell(
                          child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Color(0xff0047ff),
                                    fontWeight: FontWeight.bold),
                              )),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                        )
                      ],
                    )),
              )
            ],
          ),
        )));
  }
}
