import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vital_bloom/core/api/api_exception.dart';
import 'package:vital_bloom/core/api/api_service.dart';
import 'package:vital_bloom/core/db/shared_prefs.dart';
import 'package:vital_bloom/locator.dart';
import 'package:vital_bloom/models/user.dart';
import 'package:vital_bloom/utils/enums.dart';

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
    try {
      await _googleSignIn.disconnect();
      await getit<SharedPrefs>().removeValue(SharedPrefKey.user.toString());
    } catch (e) {
      throw e;
    }
  }

  Future<User> verifyToken(String token) async {
    try {
      final response = await getit<ApiService>().request(
        endpoint: '/auth/verify-google-token',
        method: HttpMethod.POST,
        data: {
          'idToken': token,
        },
      );
      final data = response.data;
      final User u = User.fromJson(data);
      final res = await getit<SharedPrefs>()
          .setValue(SharedPrefKey.user.toString(), json.encode(u));
      print(res);
      return u;
    } on ApiException catch (e) {
      throw e.message;
    } on Exception catch (e) {
      debugPrint('Exception: $e');
      throw e;
    }
  }

  Future<User> updateProfile(
      {required String userId, required Map<String, dynamic> payload}) async {
    try {
      final res = await getit<ApiService>().request(
          endpoint: '/user/profile/$userId',
          method: HttpMethod.PATCH,
          headers: {
            'Content-Type': 'application/json',
            'cookie': 'userId=$userId;'
          },
          data: payload);
      if (res.statusCode != 201) {
        throw ApiException.fromRes(res);
      }
      return User.fromJson(res.data);
    } on ApiException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }

  User? getUser() {
    final res =
        getit<SharedPrefs>().getValue(SharedPrefKey.user.toString()) as String?;
    if (res == null) {
      return null;
    }
    return User.fromJson(json.decode(res));
  }

  Future<User> updateHealthInfo(
      {String type = 'generalInfo',
      required String userId,
      required Map<String, dynamic> payload}) async {
    try {
      final res = await getit<ApiService>().request(
          endpoint: '/user/profile/$type/$userId',
          method: HttpMethod.PATCH,
          headers: {
            'Content-Type': 'application/json',
            'cookie': 'userId=$userId;'
          },
          data: payload);
      if (res.statusCode != 201) {
        throw ApiException.fromRes(res);
      }
      return User.fromJson(res.data);
    } on ApiException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getDashboardData({
    required String userId,
  }) async {
    try {
      final res = await getit<ApiService>().request(
        endpoint: '/api/health-score',
        method: HttpMethod.GET,
        headers: {
          'Content-Type': 'application/json',
          'cookie': 'userId=$userId;'
        },
      );
      if (res.statusCode != 200) {
        throw ApiException.fromRes(res);
      }
      return res.data as Map<String, dynamic>;
    } on ApiException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getMyGroupData({
    required String userId,
  }) async {
    try {
      final res = await getit<ApiService>().request(
        endpoint: '/user/profile/$userId',
        method: HttpMethod.GET,
        headers: {
          'Content-Type': 'application/json',
          'cookie': 'userId=$userId;'
        },
      );
      if (res.statusCode != 200) {
        throw ApiException.fromRes(res);
      }
      return res.data as Map<String, dynamic>;
    } on ApiException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<User> createGroup(
      {required String userId, required String name}) async {
    try {
      final res = await getit<ApiService>().request(
          endpoint: '/api/group/create',
          method: HttpMethod.POST,
          headers: {
            'Content-Type': 'application/json',
            'cookie': 'userId=$userId;'
          },
          data: {
            'name': name,
          });
      if (res.statusCode != 201) {
        throw ApiException.fromRes(res);
      }
      return User.fromJson(res.data);
    } on ApiException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getGroupData(
      {required String userId, required String groupId}) async {
    try {
      final res = await getit<ApiService>().request(
        endpoint: '/api/group',
        method: HttpMethod.GET,
        headers: {
          'Content-Type': 'application/json',
          'cookie': 'userId=$userId;'
        },
      );
      if (res.statusCode != 200) {
        throw ApiException.fromRes(res);
      }
      return res.data as Map<String, dynamic>;
    } on ApiException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }
}
