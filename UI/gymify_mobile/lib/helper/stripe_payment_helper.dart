import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gymify_mobile/providers/payment_provider.dart';
import 'package:provider/provider.dart';

class StripePaymentHelper {
  static Future<bool> pay(BuildContext context, {required int paymentId}) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus(); 

      final provider = context.read<PaymentProvider>();
      final clientSecret = await provider.createStripeIntent(paymentId);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Rentify",
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      debugPrint("StripeException: ${e.error.localizedMessage ?? e.error.message}");
      return false;
    }
  }

  static Future<bool> payMembership(
    BuildContext context, {
    required int userId,
    required int membershipId,
    required bool yearly,
  }) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      final provider = context.read<PaymentProvider>();

      final clientSecret = await provider.createNewIntent({
        "userId": userId,
        "membershipId": membershipId,
        "billingPeriod": yearly ? "yearly" : "monthly",
      });

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Gymify",
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      debugPrint(
        "StripeException: ${e.error.localizedMessage ?? e.error.message}",
      );
      return false;
    } catch (e) {
      debugPrint("Stripe payMembership error: $e");
      return false;
    }
  }
}