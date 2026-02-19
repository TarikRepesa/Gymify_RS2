
import 'package:gymify_desktop/models/review.dart';
import 'package:gymify_desktop/providers/base_provider.dart';

class ReviewProvider extends BaseProvider<Review> {
  ReviewProvider() : super("Review");

  @override
  Review fromJson(dynamic data) => Review.fromJson(data);
}