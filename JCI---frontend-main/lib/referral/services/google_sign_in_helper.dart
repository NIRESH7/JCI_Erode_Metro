import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInHelper {
  static GoogleSignIn? _cached;

  static GoogleSignIn get instance {
    _cached ??= _create();
    return _cached!;
  }

  /// Prefer a **Web** OAuth client ID as [serverClientId] (needed for idToken).
  /// Do NOT use the Android client ID here — that causes DEVELOPER_ERROR (10).
  /// If unset, sign-in still works via accessToken (backend supports both).
  static GoogleSignIn _create() {
    final webClientId = dotenv.maybeGet('GOOGLE_WEB_CLIENT_ID')?.trim() ??
        dotenv.maybeGet('GOOGLE_CLIENT_ID')?.trim();

    // Known Android-only client from google-services.json — never use as serverClientId.
    const androidClientId =
        '295856421490-f2k05ft6c7gqs7eh2dlhk5mfcg03lrbo.apps.googleusercontent.com';

    final useServerClient = webClientId != null &&
        webClientId.isNotEmpty &&
        webClientId != androidClientId;

    return GoogleSignIn(
      scopes: const ['email', 'openid', 'profile'],
      serverClientId: useServerClient ? webClientId : null,
    );
  }

  /// Clears cached Google session so the next sign-in is fresh.
  static Future<void> prepareSignIn() async {
    // Recreate client in case .env changed after hot restart.
    _cached = null;
    final google = instance;
    try {
      await google.signOut();
    } catch (_) {}
  }
}
