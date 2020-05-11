import 'package:flutter/material.dart';
import '../widgets/user_image_picker.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      bool isLogin, File image ,BuildContext ctx) onSubmit;
  final bool isLoading;

  AuthForm(this.onSubmit, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  String _userEmail = '';
  String _userName = '';
  String _userPass = '';
  var _isLogin = true;
  File _userAvatar;

  final _formKey = GlobalKey<FormState>();

  void _trySubmit() {
    FocusScope.of(context).unfocus();

    if (_userAvatar == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an Image'),
        ),
      );
      return;
    }

    _formKey.currentState.save();
    widget.onSubmit(_userEmail, _userPass, _userName, _isLogin, _userAvatar ,context);
  }

  void selectImage(File pickedImage) {
    _userAvatar = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(selectImage),
                  TextFormField(
                    key: ValueKey('v1'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('v2'),
                      decoration: InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('v3'),
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPass = value;
                    },
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading)
                    CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      onPressed: _trySubmit,
                    ),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new Account'
                          : 'I already have an account')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
