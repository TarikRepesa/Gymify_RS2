import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymify_mobile/config/api_config.dart';
import 'package:gymify_mobile/helper/http_helper.dart';
import 'package:http/http.dart' as http;
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../utils/session.dart';

class AuthProvider with ChangeNotifier {
  static const String apiUrl = '${ApiConfig.apiBase}/api/User/login';

  Future<String> prijava(LoginRequest request) async {
    final url = Uri.parse(apiUrl);

    final response = await http.post(
      url,
      headers: HttpHelper.getHeaders(withToken: false),
      body: jsonEncode(request.toJson()),
    );

    HttpHelper.checkResponse(response);

    final data = jsonDecode(response.body);
    final loginResp = LoginResponse.fromJson(data);

    final allowedRoles = {'Korisnik'};

    final imaPristup =
        loginResp.roles.any((role) => allowedRoles.contains(role));

    if (!imaPristup) return "Zabranjen pristup";

    Session.token = loginResp.token;
    Session.userId = loginResp.userId;
    Session.username = loginResp.userName;
    Session.roles = loginResp.roles;

    notifyListeners();

    return "OK";
  }
}