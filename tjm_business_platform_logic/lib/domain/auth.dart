import 'package:tjm_business_platform_logic/core/action_result.dart';
import 'package:tjm_business_platform_logic/core/model/platform_user.dart';
import 'package:tjm_business_platform_logic/data/auth_repository.dart';

class Auth {
  static final Auth _instance = Auth._internal();
  factory Auth() => _instance;
  Auth._internal();

  AuthRepository auth = AuthRepository();

  bool isLoggedIn() => auth.isLoggedIn();

  Future<ActionResult> login(String email, String password) async =>
      auth.login(email, password);

  Future<ActionResult> logout() async => auth.logout();

  Future<PlatformUser?> getUserProfile() async => auth.getUserProfile();
}
