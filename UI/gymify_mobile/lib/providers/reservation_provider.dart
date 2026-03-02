import 'package:gymify_mobile/models/reservation.dart';
import 'package:gymify_mobile/models/review.dart';


import 'base_provider.dart';

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super("Reservation");

  @override
  Reservation fromJson(dynamic data) {
    return Reservation.fromJson(data);
  }
}