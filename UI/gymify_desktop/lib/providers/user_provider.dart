import 'package:flutter/material.dart';
import 'package:gymify_desktop/models/search_result.dart';
import 'package:gymify_desktop/models/user.dart';
import 'package:gymify_desktop/providers/base_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  @override
  User fromJson(dynamic data) => User.fromJson(data);

  bool isLoading = false;
  List<User> items = [];

  Future<void> loadStaff() async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await get(filter: {
        "retrieveAll": true,
        "isRadnik": true,
        "isTrener": true, 
      });

      items = res.items;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<SearchResult<User>> getStaffPaged({
    required int page,
    required int pageSize,
    String? search,
    bool includeTotalCount = true,
  }) async {
    return await get(
      filter: {
        "page": page,
        "pageSize": pageSize,
        "includeTotalCount": includeTotalCount,
        "retrieveAll": false, 
        "isRadnik": true,
        "isTrener": true,
        if (search != null && search.trim().isNotEmpty) "FTS": search.trim(),
      },
    );
  }
}
