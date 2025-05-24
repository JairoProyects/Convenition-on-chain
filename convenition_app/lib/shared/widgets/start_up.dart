import 'package:flutter/material.dart';
import '../config/auth_config.dart';
import '../../home/bottom_navigation_bar.dart';
import '../../convenion/presentation/login/login_page.dart';

class SplashRedirectPage extends StatefulWidget {
  const SplashRedirectPage({super.key});

  @override
  State<SplashRedirectPage> createState() => _SplashRedirectPageState();
}

class _SplashRedirectPageState extends State<SplashRedirectPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final userId = await AuthConfig.getUserSession();

    if (!mounted) return;

    if (userId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MenuTopTabsPage(userId: userId),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
