import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app_flutter/pages/home/home_page.dart';
import 'package:todo_app_flutter/pages/auth/login/login_page.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:todo_app_flutter/theme/text_style.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (!context.mounted) return;
      _navigateToNextPage(context);
    });
    return const Scaffold(
      backgroundColor: MyAppColors.backgroundColor,
      body: Center(
        child: Text(
          "App",
          style: MyAppStyles.todoListTitleTextStyle,
        ),
      ),
    );
  }

  void _navigateToNextPage(BuildContext context) {
    if (Supabase.instance.client.auth.currentSession?.isExpired == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }
}
