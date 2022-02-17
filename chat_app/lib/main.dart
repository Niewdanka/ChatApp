import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData();
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.green,
          secondary: Colors.teal[300],
          error: Colors.red,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      home: StreamBuilder(
        //w stream: stprawdzamy czy mamy aktywny token i w zależności czy mamy czy nie
        //wyświetla się na strona do logowania(gdy nie mamy) lub ChatScreen(gdy mamy)
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          //tu jest ten warunek czy mamy token
          if (snapshot.hasData) {
            return const ChatScreen();
          }
          return const AuthScree();
        },
      ),
    );
  }
}
