import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/common/widgets/button_widget.dart';
import 'package:todo_app_flutter/common/widgets/textfield_widget.dart';
import 'package:todo_app_flutter/pages/auth/register/register_viewmodel.dart';
import 'package:todo_app_flutter/utils/dimens_util.dart';
import 'package:todo_app_flutter/gen/fonts.gen.dart';
import 'package:todo_app_flutter/theme/color_style.dart';

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
    return Consumer<RegisterViewModel>(
        builder: (context, registerViewModel, child) {
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
            _buildPasswordField(registerViewModel),
            const SizedBox(height: 20),
            _buildConfirmPasswordField(registerViewModel),
            const SizedBox(height: 20),
            _buildRegisterButton(registerViewModel),
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

  Widget _buildPasswordField(RegisterViewModel registerViewModel) {
    return TextFieldWidget(
      hint: "Password",
      controller: _passwordController,
      obscureText: registerViewModel.obscurePassword,
      suffixIcon: GestureDetector(
        onTap: registerViewModel.changeStateObscurePassword,
        child: Icon(
          registerViewModel.obscurePassword
              ? Icons.visibility
              : Icons.visibility_off,
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField(RegisterViewModel registerViewModel) {
    return TextFieldWidget(
      hint: "Confirm Password",
      controller: _rePasswordController,
      obscureText: registerViewModel.obscureRePassword,
      suffixIcon: GestureDetector(
        onTap: registerViewModel.changeStateObscureRePassword,
        child: Icon(
          registerViewModel.obscureRePassword
              ? Icons.visibility
              : Icons.visibility_off,
        ),
      ),
    );
  }

  Widget _buildRegisterButton(RegisterViewModel registerViewModel) {
    return registerViewModel.registerStatus == RegisterStatus.loading
        ? const CircularProgressIndicator(color: MyAppColors.backgroundColor)
        : ButtonWidget(
            callback: () async {
              await _handleRegister(registerViewModel);
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

  Future<void> _handleRegister(RegisterViewModel registerViewModel) async {
    await registerViewModel.register(
      _usernameController.text,
      _passwordController.text,
      _rePasswordController.text,
    );

    if (!mounted) return;

    if (registerViewModel.registerStatus == RegisterStatus.error) {
      _showSnackbar(context, registerViewModel.errorRegister);
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
