import 'dart:convert';

import 'package:gymify_mobile/config/api_config.dart';
import 'package:gymify_mobile/models/payment.dart';

import '../utils/session.dart';
import 'package:http/http.dart' as http;

import 'base_provider.dart';

class PaymentProvider extends BaseProvider<Payment> {
  PaymentProvider() : super("payment");

  @override
  Payment fromJson(dynamic data) {
    return Payment.fromJson(data);
  }

  Future<String> createStripeIntent(int paymentId) async {
  final url = "${ApiConfig.apiBase}/api/payment/$paymentId/create-intent";

  final res = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${Session.token}",
    },
  );

  if (res.statusCode < 200 || res.statusCode > 299) {
    throw Exception("API Error: ${res.statusCode} → ${res.body}");
  }

  final Map<String, dynamic> data = jsonDecode(res.body);

  return data["clientSecret"] as String;  
}

Future<String> createNewIntent(Map<String, dynamic> request) async {
  final url = "${ApiConfig.apiBase}/api/payment/create-new-intent";

  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode(request),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${Session.token}",
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Greška pri kreiranju payment intenta: ${response.body}");
  }

  final data = jsonDecode(response.body);

  return data["clientSecret"] as String;
}
}