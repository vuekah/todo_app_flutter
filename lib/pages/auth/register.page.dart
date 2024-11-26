import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/common/widgets/button.widgets.dart';
import 'package:todo_app_flutter/common/widgets/textfield.widget.dart';
import 'package:todo_app_flutter/utils/dimens.dart';
import 'package:todo_app_flutter/gen/fonts.gen.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:todo_app_flutter/pages/auth/auth.viewmodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);

    return Scaffold(
      backgroundColor: MyAppColors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
                Dimens.screenWidth > Dimens.screenHeight ? 35 : 8),
            child: _buildRegisterForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Consumer<AuthViewModel>(builder: (context, authViewModel, child) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: MyAppColors.whiteColor,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUsernameField(),
            const SizedBox(height: 20),
            _buildPasswordField(authViewModel),
            const SizedBox(height: 20),
            _buildConfirmPasswordField(authViewModel),
            const SizedBox(height: 20),
            _buildRegisterButton(authViewModel),
            const SizedBox(height: 15),
            _buildSignInLink(),
          ],
        ),
      );
    });
  }

  Widget _buildUsernameField() {
    return TextFieldWidget(
      hint: "Username",
      controller: _usernameController,
    );
  }

  Widget _buildPasswordField(AuthViewModel authViewModel) {
    return TextFieldWidget(
      hint: "Password",
      controller: _passwordController,
      obscureText: authViewModel.obscurePassword,
      suffixIcon: GestureDetector(
        onTap: authViewModel.changeStateObscurePassword,
        child: Icon(
          authViewModel.obscurePassword
              ? Icons.visibility
              : Icons.visibility_off,
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField(AuthViewModel authViewModel) {
    return TextFieldWidget(
      hint: "Confirm Password",
      controller: _rePasswordController,
      obscureText: authViewModel.obscureRePassword,
      suffixIcon: GestureDetector(
        onTap: authViewModel.changeStateObscureRePassword,
        child: Icon(
          authViewModel.obscureRePassword
              ? Icons.visibility
              : Icons.visibility_off,
        ),
      ),
    );
  }

  Widget _buildRegisterButton(AuthViewModel authViewModel) {
    return authViewModel.registerStatus == AuthStatus.loading
        ? const CircularProgressIndicator(color: MyAppColors.backgroundColor)
        : ButtonWidget(
            callback: () async {
              await _handleRegister(authViewModel);
            },
            title: "Sign up",
          );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        const SizedBox(width: 2),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Sign in",
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

  Future<void> _handleRegister(AuthViewModel authViewModel) async {
    await authViewModel.register(
      _usernameController.text,
      _passwordController.text,
      _rePasswordController.text,
    );

    if (!mounted) return;

    if (authViewModel.registerStatus == AuthStatus.error) {
      _showSnackbar(context, authViewModel.errorRegister);
    } else {
      _showSnackbar(context, 'Registration successful');
      Navigator.pop(context);
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
