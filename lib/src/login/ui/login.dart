import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: _LoginContainer(),
        ),
      ),
    );
  }
}

class _LoginContainer extends StatefulWidget {
  const _LoginContainer({Key? key}) : super(key: key);

  @override
  __LoginContainerState createState() => __LoginContainerState();
}

class __LoginContainerState extends State<_LoginContainer> {
  final key = GlobalKey<FormState>();
  String username = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    final spacing = EdgeInsets.only(top: 8.0, bottom: 8.0);

    return Form(
        child: Column(
      children: [
        Padding(
          padding: spacing,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name"),
              TextFormField(
                decoration: InputDecoration(hintText: "Jára", filled: true),
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: spacing,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Password"),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Cimrman",
                ),
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
              )
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Card(
            child: SizedBox(
              width: 256,
              height: 64,
              child: Center(
                child: Text(
                  "Login",
                  style: TextStyle(height: 40),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
