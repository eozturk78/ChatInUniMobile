import 'package:get/get.dart';

import '../models/messageListModel.dart';

class MessageController extends GetxController {
  final booking = DatePicker(msg: []).obs;
  updateBooking(List msg) {
    booking.update((val) {
      val!.msg = msg;
    });
  }
}
