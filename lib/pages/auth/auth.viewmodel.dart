import 'package:flutter/material.dart';
import 'package:todo_app_flutter/service/auth.service.dart';

enum AuthStatus { init, loading, success, error }

class AuthViewModel extends ChangeNotifier {
  bool _obscurePassword = true;
  bool _obscureRePassword = true;
  AuthStatus _loginStatus = AuthStatus.init;
  AuthStatus _registerStatus = AuthStatus.init;
  String _errorLogin = "";
  String _errorRegister = "";

  String get errorLogin => _errorLogin;
  String get errorRegister => _errorRegister;
  bool get obscurePassword => _obscurePassword;
  bool get obscureRePassword => _obscureRePassword;
  AuthStatus get loginStatus => _loginStatus;
  AuthStatus get registerStatus => _registerStatus;

  void changeStateObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void changeStateObscureRePassword() {
    _obscureRePassword = !_obscureRePassword;
    notifyListeners();
  }

  Future login(String usr, String pwd) async {
    try {
      if (usr.isNotEmpty && pwd.isNotEmpty) {
        _loginStatus = AuthStatus.loading;
        notifyListeners();
        final username = "$usr@gmail.com";
        final response = await AuthService().login(username, pwd);

        if (response.user != null) {
          _loginStatus = AuthStatus.success;
        } else {
          _loginStatus = AuthStatus.error;
          _errorLogin = "Login failed. Please check your credentials.";
        }
      } else {
        _loginStatus = AuthStatus.error;
        _errorLogin = "Username and password cannot be empty";
      }
    } catch (e) {
      _loginStatus = AuthStatus.error;
      _errorLogin = "Invalid login credentials";
    } finally {
      notifyListeners();
    }
  }

  Future register(String usr, String pwd, String rePwd) async {
    try {
      if (usr.isNotEmpty && pwd.isNotEmpty && rePwd.isNotEmpty) {
        if (pwd == rePwd) {
          _registerStatus = AuthStatus.loading;
          notifyListeners();
          final username = "$usr@gmail.com";
          final response = await AuthService().register(username, pwd);
          if (response.user != null) {
            _registerStatus = AuthStatus.success;
            _errorRegister = "Register Successfully";
          } else {
            _registerStatus = AuthStatus.error;
            _errorRegister = "Something is error! ";
          }
        } else {
          _registerStatus = AuthStatus.error;
          _errorRegister = "Re password not match!";
          //showing not match
        }
      } else {
        _registerStatus = AuthStatus.error;
        _errorRegister = "Username, Password, RePassword cannot be empty";
      }
    } catch (e) {
      _registerStatus = AuthStatus.error;
      _errorRegister = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future logout() async {
    try {
      return await AuthService().logout();
    } catch (e) {
      print(e.toString());
    } 
  }
}
