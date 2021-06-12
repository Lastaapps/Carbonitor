import 'package:carbonitor/src/constants/router_destinations.dart';
import 'package:carbonitor/src/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _CubitProvider(),
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
          Navigator.pop(context, AppRoutes.home);
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
  String userName = "";
  String password = "";
  final LoginState state;

  _LoginContainerState(this.state);

  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    return Container(
        child: Container(
            child: Container(
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 60),
                        child: Text("Login", style: TextStyle(fontSize: 45)),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Name"),
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: "jara_cimrman", filled: true),
                              onChanged: (value) {
                                setState(() {
                                  userName = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                            loginCubit.handleLoginButton(userName, password);
                          },
                          child: Container(
                            width: 140,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ))
                    ])))));
  }
}
