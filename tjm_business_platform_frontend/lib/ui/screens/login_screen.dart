import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
import 'package:tjm_business_platform/core/app_settings.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/ui/screens/main_screen.dart';
import 'package:tjm_business_platform_logic/core/action_result.dart';
import 'package:tjm_business_platform_logic/domain/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final Auth auth = Auth();

  String user = "";
  String password = "";
  bool error = false;
  bool showPassword = false;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  void _loginAction() async {
    if (user.isNotEmpty && password.isNotEmpty) {
      final result = await auth.login(user, password);

      if (!mounted) return;

      if (result == ActionResult.ok) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        setState(() => error = true);
      }
    } else {
      setState(() => error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.seedColor.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          final content = SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                companyBrand(),
                Text(
                  AppStrings.login,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (error)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      AppStrings.userOrPasswordInvalid,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 24.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: AppStrings.email,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => user = value),
                  onSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !showPassword,
                  focusNode: _passwordFocus,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: AppStrings.password,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => showPassword = !showPassword),
                    ),
                  ),
                  onChanged: (value) => setState(() => password = value),
                  onSubmitted: (_) => _loginAction(),
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loginAction,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppStrings.actionLogin,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );

          if (isDesktop) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.all(32),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: content,
                  ),
                ),
              ),
            );
          } else {
            return Center(child: content);
          }
        },
      ),
    );
  }

  Padding companyBrand() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: Image.asset(
          AppSettings.companyLogoAsset,
          width: 132.0,
          height: 132.0,
        ),
      ),
    );
  }
}
