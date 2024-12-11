import 'package:flutter/material.dart';
import 'package:todo_app_flutter/l10n/language_provider.dart';
import 'package:todo_app_flutter/pages/auth/login/login_page.dart';
import 'package:todo_app_flutter/pages/home/home_viewmodel.dart';
import 'package:todo_app_flutter/pages/settings/items/item_widget.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.whiteColor,
      appBar: AppBar(
        foregroundColor: MyAppColors.whiteColor,
        title:  Text(AppLocalizations.of(context)!.settingTitle),
      ),
      body: ListView(
        children: [
          ItemWidget(
            title: AppLocalizations.of(context)!.language,
            callBack: () {
              context.read<LanguageProvider>().changeLanguage();
            },
            suffixText: context.watch<LanguageProvider>().locale.toString(),
            icon: const Icon(Icons.language,),
          ),
          const Divider(
            height: 1,
          ),
          ItemWidget(
            title: AppLocalizations.of(context)!.logout,
            callBack: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
              context.read<HomeViewModel>().logout();
            },
            icon: const Icon(Icons.logout),
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
