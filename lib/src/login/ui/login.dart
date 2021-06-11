import 'package:carbonitor/src/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: _CubitProvider(),
        ),
      ),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  const _CubitProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => LoginCubit(),
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return _SnackStateWidget(state);
          },
        ));
  }
}

class _SnackStateWidget extends StatelessWidget {
  final LoginState state;

  const _SnackStateWidget(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        String? text;
        if (state is LoginSucceed) {
          //TODO navigation
          text = "Great success!";
        } else if (state is LoginWrong) {
          text = "Wrong input";
        } else if (state is LoginEmpty) {
          text = "Please, enter data";
        }
        if (text != null) {
          final snackBar = SnackBar(content: Text(text));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: _LoginContainer(state),
    );
  }
}

class _LoginContainer extends StatefulWidget {
  final LoginState _state;

  const _LoginContainer(this._state, {Key? key}) : super(key: key);

  @override
  _LoginContainerState createState() => _LoginContainerState(_state);
}

class _LoginContainerState extends State<_LoginContainer> {
  final key = GlobalKey<FormState>();
  String userName = "";
  String password = "";
  final LoginState state;

  _LoginContainerState(this.state);

  @override
  Widget build(BuildContext context) {
    final spacing = EdgeInsets.only(top: 8.0, bottom: 8.0);
    final donutCubit = BlocProvider.of<LoginCubit>(context);

    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: Form(
                child: Column(
          children: [
            Padding(
              padding: spacing,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name"),
                  TextFormField(
                    decoration:
                        InputDecoration(hintText: "jara_cimrman", filled: true),
                    onChanged: (value) {
                      setState(() {
                        userName = value;
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
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "top_secret_123",
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                donutCubit.handleLoginButton(userName, password);
              },
              child: Card(
                child: SizedBox(
                  width: 256,
                  height: 64,
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, height: 40),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ))));
  }
}
