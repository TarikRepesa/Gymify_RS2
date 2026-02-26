import 'package:flutter/material.dart';
import 'package:gymify_mobile/providers/image_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gymify_mobile/routes/app_routes.dart';
import 'package:gymify_mobile/providers/auth_provider.dart';
import 'package:gymify_mobile/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('bs');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),

        // kasnije dodaj:
        // ChangeNotifierProvider(create: (_) => NotificationProvider()),
        // ChangeNotifierProvider(create: (_) => TrainingProvider()),
        // ChangeNotifierProvider(create: (_) => MembershipProvider()),
      ],
      child: const GymifyApp(),
    ),
  );
}

class GymifyApp extends StatelessWidget {
  const GymifyApp({super.key});

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
      ),
    );
  }
}