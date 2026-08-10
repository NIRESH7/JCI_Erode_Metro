import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:jci/referral/services/session_service.dart';

/// Silent startup gate — no splash UI. Routes to home or login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    if (!dotenv.isInitialized) {
      await dotenv.load(fileName: kReleaseMode ? '.env.production' : '.env');
    }

    if (!mounted) return;

    final loggedIn = await SessionService.isLoggedIn();
    if (loggedIn) {
      await SessionService.refreshProfile();
    }
    if (!mounted) return;

    Get.offNamed(loggedIn ? '/' : '/member-login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(),
    );
  }
}
