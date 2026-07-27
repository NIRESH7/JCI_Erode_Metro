import 'package:get/get.dart';

class SponsorController extends GetxController {
  var _visible = true.obs;
  var _mainSponsorVisible = true.obs;

  var _copyVisible = true.obs;
  bool get getCopyVisible => _copyVisible.value;

  setCopyVisible(bool value) {
    _copyVisible.value = value;
    update();
  }

  setVisible(bool value) {
    _visible.value = value;
    update();
  }

  getVisible() => _visible.value;

  setMainSponsorVisible(bool value) => _mainSponsorVisible.value = value;

  getMainSponsorVisiblity() => _mainSponsorVisible.value;
}
