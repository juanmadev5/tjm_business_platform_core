import 'package:tjm_business_platform_logic/core/action_result.dart';
import 'package:tjm_business_platform_logic/core/model/platform_user.dart';
import 'package:supabase/supabase.dart';

class AuthRepository {
  static final AuthRepository _instance = AuthRepository._internal();
  factory AuthRepository() => _instance;
  AuthRepository._internal();

  SupabaseClient? client;
  User? currentUser;

  void initSupabase(SupabaseClient supabaseClient) {
    client = supabaseClient;
    currentUser = client?.auth.currentUser;
  }

  bool isLoggedIn() {
    return client?.auth.currentUser != null;
  }

  Future<ActionResult> login(String email, String password) async {
    try {
      final res = await client!.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (res.user != null) {
        currentUser = res.user;
        return ActionResult.ok;
      }
    } catch (e) {
      return ActionResult.error;
    }
    return ActionResult.error;
  }

  Future<ActionResult> logout() async {
    await client!.auth.signOut().then((_) {
      currentUser = null;
    });
    return ActionResult.ok;
  }

  Future<PlatformUser?> getUserProfile() async {
    if (currentUser == null) return null;
    try {
      final response = await client!
          .from('users')
          .select()
          .eq('id', currentUser!.id)
          .single();

      return PlatformUser.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}
