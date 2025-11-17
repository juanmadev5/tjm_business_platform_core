import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tjm_business_platform/core/business_specific.dart';
import 'package:tjm_business_platform/core/strings.dart';
import 'package:tjm_business_platform/screens/main_screen.dart';
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
  final FocusNode _focusNode = FocusNode();

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
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            _loginAction();
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            double horizontalPadding = constraints.maxWidth > 600 ? 200 : 16;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    minHeight: 600,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      companyBrand(),

                      Text(
                        AppStrings.login,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: .center,
                      ),

                      if (error)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            "Usuario o contraseña incorrectos",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            textAlign: .center,
                          ),
                        ),

                      const SizedBox(height: 24.0),

                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: AppStrings.email,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => setState(() => user = value),
                      ),

                      const SizedBox(height: 16.0),

                      TextField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          labelText: AppStrings.password,
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => showPassword = !showPassword),
                          ),
                        ),
                        onChanged: (value) => setState(() => password = value),
                      ),

                      const SizedBox(height: 24.0),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loginAction,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              "Iniciar sesión",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Padding companyBrand() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: Image.asset(
          BusinessSpecific.companyLogoAsset,
          width: 132.0,
          height: 132.0,
        ),
      ),
    );
  }
}
