import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gymify_mobile/models/loyalty_point.dart';
import 'package:gymify_mobile/providers/loyalty_point_provider.dart';
import 'package:gymify_mobile/providers/member_provider.dart';
import 'package:gymify_mobile/providers/membership_provider.dart';
import 'package:gymify_mobile/providers/notification_provider.dart';
import 'package:gymify_mobile/providers/payment_provider.dart';
import 'package:gymify_mobile/providers/reservation_provider.dart';
import 'package:gymify_mobile/providers/review_provider.dart';
import 'package:gymify_mobile/providers/reward_provider.dart';
import 'package:gymify_mobile/providers/training_provider.dart';
import 'package:gymify_mobile/providers/user_reward_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gymify_mobile/routes/app_routes.dart';
import 'package:gymify_mobile/providers/auth_provider.dart';
import 'package:gymify_mobile/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('bs');

  Stripe.publishableKey = "pk_test_51T6hS0CMbcejIOSaWb12W42JyQNdTJHRweDtYsN01qYQx1NFT04sUGdUIHKx1OV5MZJKvMHHpgoWzvOPi9955ZhJ002lptva2y";
  await Stripe.instance.applySettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => TrainingProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(create: (_) => MembershipProvider()),
        ChangeNotifierProvider(create: (_) => MemberProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => LoyaltyPointProvider()),
        ChangeNotifierProvider(create: (_) => RewardProvider()),
        ChangeNotifierProvider(create: (_) => UserRewardProvider()),
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