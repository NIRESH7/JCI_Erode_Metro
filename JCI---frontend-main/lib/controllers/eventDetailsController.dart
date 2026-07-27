import 'package:get/get.dart';

class EventDetailController extends GetxController {
  var visibility = true.obs;

  setVisible(bool visible) {
    visibility.value = visible;
    update();
  }

  getVisible() {
    return visibility.value;
  }
}
