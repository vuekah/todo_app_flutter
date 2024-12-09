import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/common/widgets/button_widget.dart';
import 'package:todo_app_flutter/common/widgets/textfield_widget.dart';
import 'package:todo_app_flutter/l10n/language_provider.dart';
import 'package:todo_app_flutter/pages/auth/login/login_viewmodel.dart';
import 'package:todo_app_flutter/pages/home/home_viewmodel.dart';
import 'package:todo_app_flutter/utils/dimens_util.dart';
import 'package:todo_app_flutter/gen/fonts.gen.dart';
import 'package:todo_app_flutter/pages/home/home_page.dart';
import 'package:todo_app_flutter/pages/auth/register/register_page.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              final languageProvider =
                  Provider.of<LanguageProvider>(context, listen: false);
              final currentLocale = languageProvider.locale.languageCode;
              final newLanguageCode = currentLocale == 'vi' ? 'en' : 'vi';
              languageProvider.changeLanguage(newLanguageCode);
            },
            icon: const Icon(
              Icons.language,
              size: 30,
              color: MyAppColors.whiteColor,
            ),
          ),
        ),
        backgroundColor: MyAppColors.backgroundColor,
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: MyAppColors.whiteColor,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldWidget(
                  hint: AppLocalizations.of(context)!.username,
                  controller: _usernameController,
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildPasswordField(context),
                const SizedBox(
                  height: 20,
                ),
                _buildLoginButton(context),
                const SizedBox(
                  height: 30,
                ),
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.dontHaveAccount),
        const SizedBox(width: 2),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            );
          },
          child: Text(
            AppLocalizations.of(context)!.signUpTitle,
            style: const TextStyle(
              color: MyAppColors.backgroundColor,
              fontFamily: FontFamily.inter,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return context.select((LoginViewModel lg) => lg.loginStatus) ==
            LoginStatus.loading
        ? const CircularProgressIndicator(
            color: MyAppColors.backgroundColor,
          )
        : ButtonWidget(
            callback: () async {
              await _handleLogin(context);
            },
            title: AppLocalizations.of(context)!.signInTitle,
          );
  }

  Future<void> _handleLogin(BuildContext context) async {
    await context
        .read<LoginViewModel>()
        .login(_usernameController.text, _passwordController.text);
    if (!context.mounted) return;
    if (context.read<LoginViewModel>().loginStatus == LoginStatus.success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      context.read<HomeViewModel>().resetAllState();
    } else {
      if (!mounted) return;
      switch (context.read<LoginViewModel>().errorLogin) {
        case LoginError.error:
          _showSnackbar(context, AppLocalizations.of(context)!.loginError);
          break;
        case LoginError.emptyField:
          _showSnackbar(context, AppLocalizations.of(context)!.emptyFieldError);
          break;
        case LoginError.invalidCredential:
          _showSnackbar(
              context, AppLocalizations.of(context)!.loginInvalidCredentials);
          break;
        default:
          break;
      }
    }
  }

  TextFieldWidget _buildPasswordField(BuildContext context) {
    return TextFieldWidget(
      controller: _passwordController,
      hint: AppLocalizations.of(context)!.password,
      suffixIcon: GestureDetector(
        child: Icon(context.watch<LoginViewModel>().obscurePassword
            ? Icons.visibility
            : Icons.visibility_off),
        onTap: () {
          context.read<LoginViewModel>().changeStateObscurePassword();
        },
      ),
      obscureText: context.watch<LoginViewModel>().obscurePassword,
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
