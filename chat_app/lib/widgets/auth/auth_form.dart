import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
    required this.submitAuthForm,
    required this.isLoading,
  }) : super(key: key);

  final bool isLoading;

  final Function(
    String email,
    String username,
    String password,
    File? image,
    bool isLogin,
  ) submitAuthForm;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userUsername = '';
  var _userPassword = '';
  File? _userImage;

  //Przechowywanie zdjęcia w zmiennej
  void _pickedImage(var image) {
    _userImage = image;
  }

  //funkcja która sprawdza czy wszytkie wpisane dane są poprawne
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    //mamy pewnośc że po zatwierdzeniu wszyskiego nasza klawiatura sie zamknie
    FocusScope.of(context).unfocus();

    // ignore: unnecessary_null_comparison
    if (_userImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    //jeśli wszystkie podane są poprawne wtedy zapisujemy
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitAuthForm(
        _userEmail.trim(), //.trip uzuwa białe znaki jak spacje sprzed i po
        _userUsername.trim(),
        _userPassword.trim(),
        _userImage,
        _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    UserImagePicker(
                      pickedImageFunction: _pickedImage,
                    ),
                  TextFormField(
                    key: const ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email adress';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Username must be at least 4 characters long';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _userUsername = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  widget.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? 'Login' : 'Signup'),
                        ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
