import 'package:flutter/material.dart';
import 'package:gymify_desktop/providers/auth_provider.dart';
import 'package:gymify_desktop/providers/member_provider.dart';
import 'package:gymify_desktop/providers/membership_provider.dart';
import 'package:gymify_desktop/providers/training_provider.dart';
import 'package:gymify_desktop/providers/user_provider.dart';
import 'package:gymify_desktop/routes/app_routes.dart';
import 'package:gymify_desktop/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MemberProvider()),
        ChangeNotifierProvider(create: (_) => MembershipProvider()),
        ChangeNotifierProvider(create: (_) => TrainingProvider()),
      ],
      child: const RentifyApp(),
    ),
  );
}

class RentifyApp extends StatelessWidget {
  const RentifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gymify',
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen(),
    );
  }
}
