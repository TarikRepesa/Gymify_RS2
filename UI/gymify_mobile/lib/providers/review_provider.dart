import 'package:gymify_mobile/models/review.dart';


import 'base_provider.dart';

class ReviewProvider extends BaseProvider<Review> {
  ReviewProvider() : super("Review");

  @override
  Review fromJson(dynamic data) {
    return Review.fromJson(data);
  }
}