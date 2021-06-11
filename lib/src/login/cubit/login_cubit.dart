import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static final _username = "admin";
  static final _password = "password";

  void handleLoginButton(String userName, String password) {
    print("Handling user click $userName, $password");

    if (userName == "" || password == "") {
      emit(LoginEmpty());
      return;
    }

    if (userName == _username && password == _password) {
      emit(LoginSucceed());
      return;
    }

    emit(LoginWrong());
  }
}
