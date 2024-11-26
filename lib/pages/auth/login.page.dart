import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/common/widgets/button.widgets.dart';
import 'package:todo_app_flutter/common/widgets/textfield.widget.dart';
import 'package:todo_app_flutter/utils/dimens.dart';
import 'package:todo_app_flutter/gen/fonts.gen.dart';
import 'package:todo_app_flutter/pages/home/home.page.dart';
import 'package:todo_app_flutter/pages/auth/register.page.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:todo_app_flutter/pages/auth/auth.viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);
    return Scaffold(
      backgroundColor: MyAppColors.backgroundColor,
      body: Center(
        child: Consumer<AuthViewModel>(builder: (context, value, child) {
          return Container(
            margin: EdgeInsets.all(
                Dimens.screenWidth > Dimens.screenHeight ? 35 : 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: MyAppColors.whiteColor,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldWidget(
                  hint: "Username",
                  controller: _usernameController,
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildPasswordField(value),
                const SizedBox(
                  height: 20,
                ),
                _buildLoginButton(value),
                const SizedBox(
                  height: 15,
                ),
                _buildSignUpLink()
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        const SizedBox(width: 2),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            );
          },
          child: const Text(
            "Sign up",
            style: TextStyle(
              color: MyAppColors.backgroundColor,
              fontFamily: FontFamily.inter,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(AuthViewModel authViewModel) {
    return authViewModel.loginStatus == AuthStatus.loading
        ? const CircularProgressIndicator(
            color: MyAppColors.backgroundColor,
          )
        : ButtonWidget(
            callback: () async {
              await _handleLogin(authViewModel);
            },
            title: "Sign in",
          );
  }

  Future<void> _handleLogin(AuthViewModel authViewModel) async {
    await authViewModel.login(
        _usernameController.text, _passwordController.text);
    if (authViewModel.loginStatus == AuthStatus.success) {
    if(!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
    if(!mounted) return;
      _showSnackbar(context, authViewModel.errorLogin);
    }
  }

  TextFieldWidget _buildPasswordField(AuthViewModel value) {
    return TextFieldWidget(
      controller: _passwordController,
      hint: "Password",
      suffixIcon: GestureDetector(
        child: Icon(
            value.obscurePassword ? Icons.visibility : Icons.visibility_off),
        onTap: () {
          value.changeStateObscurePassword();
        },
      ),
      obscureText: value.obscurePassword,
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
