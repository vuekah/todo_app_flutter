import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/common/widgets/button_widget.dart';
import 'package:todo_app_flutter/common/widgets/textfield_widget.dart';
import 'package:todo_app_flutter/l10n/language_provider.dart';
import 'package:todo_app_flutter/pages/auth/register/register_viewmodel.dart';
import 'package:todo_app_flutter/utils/dimens_util.dart';
import 'package:todo_app_flutter/gen/fonts.gen.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          const SizedBox(
            height: 30,
          ),
          _buildSignInLink(),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFieldWidget(
      hint: AppLocalizations.of(context)!.username,
      controller: _usernameController,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Selector<RegisterViewModel, bool>(
      builder: (context, value, child) => TextFieldWidget(
        hint: AppLocalizations.of(context)!.password,
        controller: _passwordController,
        obscureText: value,
        suffixIcon: GestureDetector(
          onTap: context.read<RegisterViewModel>().changeStateObscurePassword,
          child: Icon(
            value ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      selector: (context, value) => value.obscurePassword,
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return Selector<RegisterViewModel, bool>(
      builder: (context, value, child) => TextFieldWidget(
        hint: AppLocalizations.of(context)!.confirmPassword,
        controller: _rePasswordController,
        obscureText: value,
        suffixIcon: GestureDetector(
          onTap: context.read<RegisterViewModel>().changeStateObscureRePassword,
          child: Icon(
            value ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      selector: (context, value) => value.obscureRePassword,
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
            title: AppLocalizations.of(context)!.signUpTitle,
          );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.alreadyHaveAccount),
        const SizedBox(width: 2),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            AppLocalizations.of(context)!.signInTitle,
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

  Future<void> _handleRegister(BuildContext context) async {
    await context.read<RegisterViewModel>().register(
          _usernameController.text,
          _passwordController.text,
          _rePasswordController.text,
        );

    if (!context.mounted) return;

    if (context.read<RegisterViewModel>().registerStatus ==
        RegisterStatus.error) {
      switch (context.read<RegisterViewModel>().errorRegister) {
        case RegisterErrorMessage.errorSomething:
          _showSnackbar(context, AppLocalizations.of(context)!.errorSomething);
          break;
        case RegisterErrorMessage.errorRePassword:
          _showSnackbar(context, AppLocalizations.of(context)!.errorRePassword);
          break;
        case RegisterErrorMessage.emptyFieldError:
          _showSnackbar(context, AppLocalizations.of(context)!.emptyFieldError);
          break;
        default:
          break;
      }
    } else {
      _showSnackbar(context, AppLocalizations.of(context)!.registerSuccess);
      Navigator.pop(context);
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
