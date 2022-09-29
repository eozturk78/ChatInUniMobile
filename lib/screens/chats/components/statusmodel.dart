import 'package:get/get.dart';
import 'model.dart';

class DateController extends GetxController {
  final booking = Booking(date: "null").obs;
  updateBooking(String date) {
    booking.update((val) {
      val!.date = date;
    });
  }
}
