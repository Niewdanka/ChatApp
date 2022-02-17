// ignore_for_file: avoid_print

import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScree extends StatefulWidget {
  const AuthScree({Key? key}) : super(key: key);

  @override
  _AuthScreeState createState() => _AuthScreeState();
}

class _AuthScreeState extends State<AuthScree> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  //funkcja która tworzy nam użytkownika i pozwala na zalogowanie się
  void _submitAuthForm(
    String email,
    String username,
    String password,
    File? image,
    bool isLogin,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //zapisywanie zdjęcia w firebase storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');

        await ref.putFile(image!);

        //przechowuje nasze zdjęcie w linku jak np na discordzie jest link i wyświetla nam się zdjęcie
        final url = await ref.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set(
          {
            'username': username,
            'email': email,
            'image_url': url,
          },
        );
      }
    } on PlatformException catch (error) {
      var message = 'An error occurred, please check your credentials';

      if (error.message != null) {
        message = error.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: AuthForm(
          submitAuthForm: _submitAuthForm,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}
