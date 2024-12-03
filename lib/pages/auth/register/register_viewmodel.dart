import 'package:flutter/material.dart';
import 'package:todo_app_flutter/service/auth_service.dart';

enum RegisterStatus { init, loading, success, error }

enum RegisterErrorMessage {
  init,
  errorSomething,
  errorRePassword,
  emptyFieldError
}

class RegisterViewModel extends ChangeNotifier {
  bool _obscurePassword = true;
  RegisterStatus _registerStatus = RegisterStatus.init;
  bool _obscureRePassword = true;
  RegisterErrorMessage _errorRegister = RegisterErrorMessage.init;

  RegisterErrorMessage get errorRegister => _errorRegister;
  bool get obscurePassword => _obscurePassword;
  bool get obscureRePassword => _obscureRePassword;
  RegisterStatus get registerStatus => _registerStatus;

  void changeStateObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void changeStateObscureRePassword() {
    _obscureRePassword = !_obscureRePassword;
    notifyListeners();
  }

  Future register(String usr, String pwd, String rePwd) async {
    try {
      if (usr.isNotEmpty && pwd.isNotEmpty && rePwd.isNotEmpty) {
        if (pwd == rePwd) {
          _registerStatus = RegisterStatus.loading;
          notifyListeners();
          final username = "$usr@gmail.com";
          final response = await AuthService().register(username, pwd);
          if (response.user != null) {
            _registerStatus = RegisterStatus.success;
          } else {
            _registerStatus = RegisterStatus.error;
            _errorRegister = RegisterErrorMessage.errorSomething;
          }
        } else {
          _registerStatus = RegisterStatus.error;
          _errorRegister = RegisterErrorMessage.errorRePassword;
          //showing not match
        }
      } else {
        _registerStatus = RegisterStatus.error;
        _errorRegister = RegisterErrorMessage.emptyFieldError;
      }
    } catch (e) {
      _registerStatus = RegisterStatus.error;
      _errorRegister =RegisterErrorMessage.errorSomething;
    } finally {
      notifyListeners();
    }
  }
}
