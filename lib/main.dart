import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app_flutter/pages/splash.page.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:todo_app_flutter/theme/text_style.dart';
import 'package:todo_app_flutter/pages/auth/auth.viewmodel.dart';
import 'package:todo_app_flutter/pages/home/home.viewmodel.dart';

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
        ChangeNotifierProvider(create: (_) => ViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: MyAppColors.backgroundColor,
                titleTextStyle: MyAppStyles.titleAppbarTextStyle)),
        home: const SplashPage(),
      ),
    );
  }
}
