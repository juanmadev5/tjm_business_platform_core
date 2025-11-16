import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tjm_business_platform/core/business_specific.dart';
import 'package:tjm_business_platform/core/strings.dart';
import 'package:tjm_business_platform/data/provider.dart';
import 'package:tjm_business_platform/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  Provider provider = Provider();

  String user = "";
  String password = "";
  bool error = false;
  bool showPassword = false;
  final FocusNode _focusNode = FocusNode();

  void _loginAction() {
    if (user.isNotEmpty && password.isNotEmpty) {
      provider.login(user, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      setState(() {
        error = true;
      });
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
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            _loginAction();
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                companyBrand(),
                Text(AppStrings.login, style: TextStyle(fontSize: 18.0)),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: SizedBox(
                    width: 320.0,
                    height: 64.0,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: AppStrings.email,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          user = value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: SizedBox(
                    width: 320.0,
                    height: 64.0,
                    child: TextField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        labelText: AppStrings.password,
                        border: OutlineInputBorder(),
                        suffix: GestureDetector(
                          child: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: SizedBox(
                    width: 128,
                    height: 64,
                    child: FloatingActionButton(
                      onPressed: () => {_loginAction()},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Iniciar sesion"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
