import 'package:flutter/material.dart';
import 'package:tjm_business_platform/ui/screens/login_screen.dart';
import 'package:tjm_business_platform_logic/core/model/platform_user.dart';
import 'package:tjm_business_platform_logic/core/role.dart';
import 'package:tjm_business_platform_logic/domain/auth.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int screenIndex = 0;
  final Data data = Data();
  final Auth auth = Auth();

  List<Role> assignedRoles = [];
  PlatformUser? user;
  bool isLoading = true;
  String? errorMessage;

  final ValueNotifier<int> refreshToken = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => isLoading = true);
    try {
      final profile = await auth.getUserProfile();
      if (!mounted) return;

      if (profile == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'No se encontraron datos de usuario.';
        });
        return;
      }

      setState(() {
        user = profile;
        assignedRoles = [profile.userRole];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error al cargar el perfil: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: Text("Cargando...")));
    }
    if (errorMessage != null) {
      return Scaffold(body: Center(child: Text(errorMessage!)));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          "${user!.name} ${user!.lastName}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Text("in development"),
    );
  }
}
