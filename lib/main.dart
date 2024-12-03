import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app_flutter/l10n/language_provider.dart';
import 'package:todo_app_flutter/pages/home/home_viewmodel.dart';
import 'package:todo_app_flutter/pages/splash_page.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:todo_app_flutter/theme/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String anonKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxd2J0ZWppeHpuaG1veGl0Z2NrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA3MDgwOTMsImV4cCI6MjA0NjI4NDA5M30.uhOegJf5C6ojGpk3pi34hkFMLASW_TpK8hNDld7QpJo";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://tqwbtejixznhmoxitgck.supabase.co',
    anonKey: anonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeViewModel()),
          ChangeNotifierProvider(create: (_) => LanguageProvider())
        ],
        child: Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
          return MaterialApp(
            locale: languageProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate
            ],
            supportedLocales: const [
              Locale('vi'),
              Locale('en'),
            ],
            theme: ThemeData(
                appBarTheme: const AppBarTheme(
                    backgroundColor: MyAppColors.backgroundColor,
                    titleTextStyle: MyAppStyles.titleAppbarTextStyle)),
            home: const SplashPage(),
          );
        }));
  }
}
