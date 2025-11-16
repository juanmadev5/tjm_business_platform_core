import 'package:intl/intl.dart';
import 'package:tjm_business_platform/data/model/user.dart';
import 'package:tjm_business_platform/data/state/login_state.dart';
import 'package:tjm_business_platform/data/state/role/role.dart';

class Provider {
  Provider._();

  static final Provider _instance = Provider._();

  factory Provider() {
    return _instance;
  }

  String name = "Juan Manuel Velazquez";
  String user = "";
  String password = "";
  LoginState loginState = LoginState.waiting;
  List<Role> userRole = [];

  void logout() {
    user = "";
    password = "";
    loginState = LoginState.waiting;
    userRole = [];
  }

  final DateTime businessStartDate = DateTime(2025, 11, 1);

  String getBusinessStartPeriod() {
    final formatter = DateFormat('MMMM yyyy', 'es');
    return formatter.format(businessStartDate);
  }

  int getCurrentWeekNumber() {
    final now = DateTime.now();
    // ISO 8601: semana 1 es la que tiene el primer jueves del año
    final dayOfYear = int.parse(DateFormat("D").format(now));
    return ((dayOfYear - now.weekday + 10) / 7).floor();
  }

  String getTodayDateFormatted() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d \'de\' MMMM \'de\' yyyy', 'es');
    return formatter.format(now);
  }

  String getTodayDate() {
    final now = DateTime.now();
    final formatter = DateFormat.yMd();
    return formatter.format(now);
  }

  LoginState login(String user, String password) {
    userRole.add(Role.admin);
    this.user = user;
    this.password = password;

    loginState = LoginState.success;
    return loginState;
  }

  List<Role> getCurrentRole() {
    return userRole;
  }

  PlatformUser getUserData() {
    return PlatformUser(name: "admin", email: user, userRole: userRole[0]);
  }
}
