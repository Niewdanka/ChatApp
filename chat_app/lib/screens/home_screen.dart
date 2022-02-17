import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height * 0.1,
          width: double.infinity,
          color: Colors.red,
          child: const Center(
            child: Text('HomeScreen'),
          ),
        ),
      ),
    );
  }
}
