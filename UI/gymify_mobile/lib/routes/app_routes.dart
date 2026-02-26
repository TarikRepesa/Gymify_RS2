import 'package:flutter/material.dart';
import 'package:gymify_mobile/screens/base_screen.dart';
import 'package:gymify_mobile/screens/home_screen.dart';
import 'package:gymify_mobile/screens/login_screen.dart';
import 'package:gymify_mobile/screens/register_screen.dart';



class AppRoutes {
  static const String base = '/base-screen';
  static const String login = '/login';
  static const String register = '/register';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case base:
        return MaterialPageRoute(builder: (_) => const BaseMobileScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      default:
        return null;
    }
  }
}
