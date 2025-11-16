import 'package:tjm_business_platform_logic/data/auth_repository.dart';
import 'package:tjm_business_platform_logic/data/data_repository.dart';
import 'package:supabase/supabase.dart';

class ClientLoader {
  static final ClientLoader _instance = ClientLoader._internal();

  factory ClientLoader() => _instance;

  ClientLoader._internal();

  final DataRepository _dataRepository = DataRepository();

  final AuthRepository _auth = AuthRepository();

  late final SupabaseClient _client;

  void initialize({required String supabaseUrl, required String supabaseKey}) {
    _client = SupabaseClient(supabaseUrl, supabaseKey);
    _dataRepository.initSupabase(_client);
    _auth.initSupabase(_client);
  }
}
