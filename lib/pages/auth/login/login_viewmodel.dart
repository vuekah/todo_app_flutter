import 'package:flutter/material.dart';
import 'package:todo_app_flutter/service/auth_service.dart';

enum LoginStatus { init, loading, success, error }

enum LoginError { init, error, invalidCredential, emptyField }

class LoginViewModel extends ChangeNotifier {
  bool _obscurePassword = true;
  LoginStatus _loginStatus = LoginStatus.init;
  LoginError _errorLogin = LoginError.init;

  bool get obscurePassword => _obscurePassword;
  LoginStatus get loginStatus => _loginStatus;
  LoginError get errorLogin => _errorLogin;

  void changeStateObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future login(String usr, String pwd) async {
    try {
      if (usr.isNotEmpty && pwd.isNotEmpty) {
        _loginStatus = LoginStatus.loading;
        notifyListeners();
        final username = "$usr@gmail.com";
        final response = await AuthService().login(username, pwd);

        if (response.user != null) {
          _loginStatus = LoginStatus.success;
        } else {
          _loginStatus = LoginStatus.error;
          _errorLogin = LoginError.error;
        }
      } else {
        _loginStatus = LoginStatus.error;
        _errorLogin = LoginError.emptyField;
      }
    } catch (e) {
      _loginStatus = LoginStatus.error;
      _errorLogin = LoginError.invalidCredential;
    } finally {
      notifyListeners();
    }
  }
}
