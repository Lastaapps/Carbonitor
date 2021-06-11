part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginWrong extends LoginState {}

class LoginEmpty extends LoginState {}

class LoginSucceed extends LoginState {}
