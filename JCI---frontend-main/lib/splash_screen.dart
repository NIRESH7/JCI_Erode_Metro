import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jci/referral/services/session_service.dart';
import 'package:jci/widgets/jci_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _assetNutzLogo = 'assets/images/logo.svg';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
    unawaited(_precacheSplashAssets());
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(seconds: 3));

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

  Future<void> _precacheSplashAssets() async {
    if (!mounted) return;

    await Future.wait([
      precacheImage(const AssetImage(JciLogo.assetPath), context),
      _precacheSvg(_assetNutzLogo),
    ]);
  }

  Future<void> _precacheSvg(String asset) async {
    final loader = SvgAssetLoader(asset);
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logoWidth = JciLogo.splashWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: JciLogo(width: logoWidth),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: math.max(28, constraints.maxHeight * 0.04),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Developed By',
                        style: TextStyle(
                          fontFamily: 'pop-med',
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SvgPicture.asset(
                        _assetNutzLogo,
                        height: 36,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
