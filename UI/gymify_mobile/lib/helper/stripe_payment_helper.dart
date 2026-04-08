import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gymify_mobile/models/payment_intent_start_response.dart';
import 'package:gymify_mobile/providers/payment_provider.dart';
import 'package:provider/provider.dart';

class StripePaymentHelper {
  static Future<PaymentIntentStartResponse?> payMembership(
    BuildContext context, {
    required int userId,
    required int membershipId,
    required bool yearly,
  }) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      final provider = context.read<PaymentProvider>();

      final paymentStart = await provider.createNewIntent({
        "userId": userId,
        "membershipId": membershipId,
        "billingPeriod": yearly ? "yearly" : "monthly",
      });

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentStart.clientSecret,
          merchantDisplayName: "Gymify",
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return paymentStart;
    } on StripeException {
      return null;
    } catch (_) {
      return null;
    }
  }
}