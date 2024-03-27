import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vital_bloom/core/api/api_exception.dart';
import 'package:vital_bloom/core/api/api_service.dart';
import 'package:vital_bloom/locator.dart';

import '../core/api/api_enums.dart';

class AuthService {
  static final _googleSignIn = GoogleSignIn(
    clientId:
        '83258358525-8et5c2todss8mtfn00rnja86rg2lfjuh.apps.googleusercontent.com',
    scopes: [
      'email',
      'openid',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
  );
  Future<GoogleSignInAccount?> login() async {
    return _googleSignIn.signIn();
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
  }

  Future verifyToken(String token) async {
    try {
      final response = await getit<ApiService>().request(
        endpoint: '/auth/verify-google-token',
        method: HttpMethod.POST,
        data: {
          'idToken': token,
        },
      );
      return response;
    } on ApiException catch (e) {
      throw e.message;
    } on Exception catch (e) {
      debugPrint('Exception: $e');
      throw e;
    }
  }
}
