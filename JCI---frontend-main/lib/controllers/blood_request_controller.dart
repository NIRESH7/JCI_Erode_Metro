import 'package:get/get.dart';
import 'package:jci/models/blood_request_model.dart';
import 'package:jci/services/blood_request_service.dart';

class BloodRequestController extends GetxController {
  var visibility = true.obs;

  setVisible(bool visible) {
    visibility.value = visible;
    update();
  }

  getVisible() {
    return visibility.value;
  }

  RxList bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ].obs;

  RxList noOfUnits = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ].obs;

  RxInt status = 0.obs;
  RxString responseMessage = ''.obs;

  BloodRequestList requestList = BloodRequestList();
  BloodRequestInfo requestInfo = BloodRequestInfo();

  Future<void> getBloodRequests() async {
    var response = await BloodRequestService().getBloodRequests();
    if (response['status'] == 200) {
      status.value = 1;
      requestList = BloodRequestList.fromJson(response['response']);
    } else {
      status.value = 0;
      responseMessage.value = 'Error Occurred! Please try again.';
    }
    update();
  }

  Future<void> getSingleBloodRequests({required String id}) async {
    var response = await BloodRequestService().getSingleBloodRequest(id: id);
    if (response['status'] == 200) {
      status.value = 1;
      requestInfo = BloodRequestInfo.fromJson(response['response']['data']['info']);
    } else {
      status.value = 0;
      responseMessage.value = 'Error Occurred! Please try again.';
    }
    update();
  }

  Future<void> createBloodRequest({required CreateBloodRequestModel data}) async {
    var response = await BloodRequestService().createBloodRequest(data: data);
    if (response['error'] != null) {
      status.value = 0;
      responseMessage.value = 'Cannot reach server. Check your connection and try again.';
    } else if (response['status'] == 200) {
      final info = response['response']?['data']?['info']?.toString() ?? '';
      if (info.toLowerCase().contains('success')) {
        status.value = 1;
        responseMessage.value = info;
      } else {
        status.value = 0;
        responseMessage.value = info.isNotEmpty ? info : 'Failed to create blood request.';
      }
    } else {
      status.value = 0;
      responseMessage.value = response['response']?['data']?['info']?.toString() ??
          'Error occurred! Please try again.';
    }
    update();
  }
}
