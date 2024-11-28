import 'package:flutter/material.dart';
import 'package:todo_app_flutter/service/auth_service.dart';

enum LoginStatus { init, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  bool _obscurePassword = true;
  LoginStatus _loginStatus = LoginStatus.init;
  String _errorLogin = "";

  String get errorLogin => _errorLogin;
  bool get obscurePassword => _obscurePassword;
  LoginStatus get loginStatus => _loginStatus;

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
          _errorLogin = "Login failed. Please check your credentials.";
        }
      } else {
        _loginStatus = LoginStatus.error;
        _errorLogin = "Username and password cannot be empty";
      }
    } catch (e) {
      _loginStatus = LoginStatus.error;
      _errorLogin = "Invalid login credentials";
    } finally {
      notifyListeners();
    }
  }

 
}
