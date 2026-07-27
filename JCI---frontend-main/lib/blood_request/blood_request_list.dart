import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jci/controllers/blood_request_controller.dart';
import 'package:jci/models/blood_request_model.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/titles.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodRequestList extends StatefulWidget {
  const BloodRequestList({super.key});

  @override
  State<BloodRequestList> createState() => _BloodRequestListState();
}

class _BloodRequestListState extends State<BloodRequestList> {
  Size _size = Size.zero;
  double _spacing = 15.0;
  BloodRequestController _bloodRequestController = Get.put(BloodRequestController());
  BloodRequestInfo info = BloodRequestInfo();
  Future<BloodRequestInfo?> _bloodRequests = Future.value();
  final String id = Get.parameters['id'] ?? '';

  Future<BloodRequestInfo?> _getSingleBloodRequests() async {
    await _bloodRequestController.getSingleBloodRequests(id: id);
    if (_bloodRequestController.status.value != 1) {
      Get.snackbar(
        'Error',
        _bloodRequestController.responseMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      return BloodRequestInfo();
    }
    return _bloodRequestController.requestInfo;
  }

  @override
  void initState() {
    _bloodRequests = _getSingleBloodRequests();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloodRequests = _getSingleBloodRequests();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustAppBar(Titles.viewBloodRequest).initAppBar(),
      body: FutureBuilder(
        future: _bloodRequests,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              info = snapshot.data as BloodRequestInfo;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 22,
                          color: Color(0xff23346B),
                        ),
                        SizedBox(width: 8.0),
                        SizedBox(
                          width: _size.width * 0.75,
                          child: Text(
                            info.nameOfPatient ?? 'Patient Name',
                            maxLines: 2,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: _spacing),
                    Row(
                      children: [
                        Icon(
                          Icons.bloodtype_outlined,
                          size: 22,
                          color: Color(0xff23346B),
                        ),
                        SizedBox(width: 8.0),
                        SizedBox(
                          width: _size.width * 0.75,
                          child: Text(info.bloodGroup ?? 'Blood Group', maxLines: 1),
                        ),
                      ],
                    ),
                    SizedBox(height: _spacing),
                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 22,
                          color: Color(0xff23346B),
                        ),
                        SizedBox(width: 8.0),
                        SizedBox(
                          width: _size.width * 0.75,
                          child: Text('${info.noOfUnits ?? '--'} Units', maxLines: 1),
                        ),
                      ],
                    ),
                    SizedBox(height: _spacing),
                    Row(
                      children: [
                        Icon(
                          Icons.local_hospital_outlined,
                          size: 22,
                          color: Color(0xff23346B),
                        ),
                        SizedBox(width: 8.0),
                        SizedBox(
                          width: _size.width * 0.75,
                          child: Text(info.hospitalName ?? 'Hospital Name',
                              maxLines: 2), //TODO: Need to use the correct value
                        ),
                      ],
                    ),
                    SizedBox(height: _spacing),
                    Row(
                      children: [
                        Icon(
                          Icons.location_searching_outlined,
                          size: 22,
                          color: Color(0xff23346B),
                        ),
                        SizedBox(width: 8.0),
                        SizedBox(
                          width: _size.width * 0.75,
                          child: Text(info.location ?? 'Hospital Location', maxLines: 4),
                        ),
                      ],
                    ),
                    SizedBox(height: _spacing),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outlined,
                          size: 22,
                          color: Color(0xff23346B),
                        ),
                        SizedBox(width: 8.0),
                        SizedBox(
                          width: _size.width * 0.75,
                          child: Text(info.attender ?? 'Attender name', maxLines: 2),
                        ),
                      ],
                    ),
                    SizedBox(height: _spacing),
                    Row(
                      children: [
                        Icon(
                          Icons.call_outlined,
                          size: 22,
                          color: Color(0xff23346B),
                        ),
                        SizedBox(width: 8.0),
                        SizedBox(
                          width: _size.width * 0.75,
                          child: InkWell(
                             onTap: () async {
                              if(info.contact!=null){
                                final Uri url = Uri(scheme: 'tel', path: '+91${info.contact}');
                                if(! await launchUrl(url)){
                                  Get.snackbar('Error', 'Error opening dialer. Please try again');
                                }
                              }
                             },
                              child: Text('+91${info.contact ?? '--'}', maxLines: 1)),
                        ),
                      ],
                    ),
                    SizedBox(height: _spacing),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 22,
                          color: Color(0xff23346B),
                        ),
                        SizedBox(width: 8.0),
                        SizedBox(
                          width: _size.width * 0.75,
                          child: Text(info.createdAt ?? 'Created Time', maxLines: 2),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            default:
              return Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }
}
