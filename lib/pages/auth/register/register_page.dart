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

    return ChangeNotifierProvider(
      create: (context) => RegisterViewModel(),
      builder:(context,child)=> Scaffold(
        backgroundColor: MyAppColors.backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(
                  Dimens.screenWidth > Dimens.screenHeight ? 35 : 8),
              child: _buildRegisterForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
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
          _buildPasswordField(context),
          const SizedBox(height: 20),
          _buildConfirmPasswordField(context),
          const SizedBox(height: 20),
          _buildRegisterButton(context),
          const SizedBox(height: 15),
          _buildSignInLink(),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFieldWidget(
      hint: "Username",
      controller: _usernameController,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFieldWidget(
      hint: "Password",
      controller: _passwordController,
      obscureText: context.watch<RegisterViewModel>().obscurePassword,
      suffixIcon: GestureDetector(
        onTap: context.read<RegisterViewModel>().changeStateObscurePassword,
        child: Icon(
          context.watch<RegisterViewModel>().obscurePassword
              ? Icons.visibility
              : Icons.visibility_off,
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return TextFieldWidget(
      hint: "Confirm Password",
      controller: _rePasswordController,
      obscureText: context.watch<RegisterViewModel>().obscureRePassword,
      suffixIcon: GestureDetector(
        onTap: context.read<RegisterViewModel>().changeStateObscureRePassword,
        child: Icon(
          context.watch<RegisterViewModel>().obscureRePassword
              ? Icons.visibility
              : Icons.visibility_off,
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return context.read<RegisterViewModel>().registerStatus ==
            RegisterStatus.loading
        ? const CircularProgressIndicator(color: MyAppColors.backgroundColor)
        : ButtonWidget(
            callback: () async {
              await _handleRegister(context);
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

  Future<void> _handleRegister(BuildContext context) async {
    await context.read<RegisterViewModel>().register(
          _usernameController.text,
          _passwordController.text,
          _rePasswordController.text,
        );

    if (!context.mounted) return;

    if (context.watch<RegisterViewModel>().registerStatus ==
        RegisterStatus.error) {
      _showSnackbar(context, context.read<RegisterViewModel>().errorRegister);
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
