import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jci/controllers/blood_request_controller.dart';
import 'package:jci/models/blood_request_model.dart';
import 'package:jci/models/membersModel.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/custom_textfield.dart';
import 'package:jci/widgets/titles.dart';

class BloodRequest extends StatefulWidget {
  const BloodRequest({Key? key}) : super(key: key);

  @override
  State<BloodRequest> createState() => _BloodRequestState();
}

class _BloodRequestState extends State<BloodRequest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _patientNameController;
  late TextEditingController _hospitalNameController;
  late TextEditingController _hospitalLocationController;
  late TextEditingController _contactPersonNameController;
  late TextEditingController _contactNumberController;
  String? _bloodGroup;
  String? _noOfUnits;
  String? _verifiedBy;
  BloodRequestController bloodRequestController = Get.put(BloodRequestController());
  String u = dotenv.get("URL");
  List<MembersModel> _memberList = [];
  List<MembersModel> _boardMembersList = [];
  Future<List<MembersModel>> membersInfo = Future.value([]);

  Future<List<MembersModel>> _loadMembersInfo({required String type}) async {
    var _routes;
    List<MembersModel> list = [];
    switch (type) {
      case 'bm':
        list = _boardMembersList;
        _routes = "boardmembers";
        break;
      case 'mem':
        list = _memberList;
        _routes = "allmembers";
        break;
      case 'pp':
        _routes = "designation";
        break;
    }

    Uri url = Uri.parse("$u/member/$_routes");

    final _response;
    var _jsonData;

    _response = await http.get(url);

    var _responseData = json.decode(_response.body);
    _jsonData = _responseData['response']['data']['info'];

    list.clear();

    if (_jsonData != "Not Found") {
      for (var members in _jsonData) {
        MembersModel _mem = MembersModel.fromJson(members);
        list.add(_mem);
      }
    }

    return list;
  }

  Future<void> createBloodRequest() async {
    if (_formKey.currentState!.validate() && _bloodGroup != null && _noOfUnits != null && _verifiedBy != null) {
      bloodRequestController.setVisible(false);
      await bloodRequestController.createBloodRequest(
        data: CreateBloodRequestModel(
          nameOfPatient: _patientNameController.text,
          bloodGroup: _bloodGroup!,
          noOfUnits: _noOfUnits!,
          hospitalName: _hospitalNameController.text,
          location: _hospitalLocationController.text,
          attender: _contactPersonNameController.text,
          contact: _contactNumberController.text,
          verifiedBy: _verifiedBy!,
        ),
      );
      bloodRequestController.setVisible(true);
      if (bloodRequestController.status.value == 1) {
        Get.back();
      }
      final snackBar = SnackBar(
        content: Text(bloodRequestController.responseMessage.value),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text('Please fill all the fields'),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    _patientNameController = TextEditingController();
    _hospitalNameController = TextEditingController();
    _hospitalLocationController = TextEditingController();
    _contactPersonNameController = TextEditingController();
    _contactNumberController = TextEditingController();
    membersInfo = _loadMembersInfo(type: 'mem');
    super.initState();
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _hospitalNameController.dispose();
    _hospitalLocationController.dispose();
    _contactPersonNameController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(Titles.bloodRequest).initAppBar(),
      body: FutureBuilder(
        future: membersInfo,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: const Text(
                            'Create Blood Request',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: _patientNameController,
                          labelText: 'Patient Name',
                          hintText: 'Enter Patient Name',
                          autoValidateMode: AutovalidateMode.disabled,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please enter Patient Name';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: DropdownButtonFormField(
                            value: _bloodGroup,
                            items: bloodRequestController.bloodGroups.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                _bloodGroup = val.toString();
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              labelText: 'Blood Group',
                              helperText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 10.0,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                // borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                // borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: DropdownButtonFormField(
                            value: _noOfUnits,
                            items: bloodRequestController.noOfUnits.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                _noOfUnits = val.toString();
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              labelText: 'No Of Units',
                              helperText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 10.0,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                // borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                // borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: _hospitalNameController,
                          labelText: 'Hospital/Blood Bank Name',
                          hintText: 'Enter Hospital/Blood Bank Name',
                          autoValidateMode: AutovalidateMode.disabled,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please enter Hospital/Blood Bank Name';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: _hospitalLocationController,
                          labelText: 'Hospital/Blood Bank Location',
                          hintText: 'Enter Hospital/Blood Bank Location',
                          autoValidateMode: AutovalidateMode.disabled,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please enter Hospital/Blood Bank Location';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: _contactPersonNameController,
                          labelText: 'Contact Person Name',
                          hintText: 'Enter Contact Person Name',
                          autoValidateMode: AutovalidateMode.disabled,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please enter Contact Person Name';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: _contactNumberController,
                          labelText: 'Contact Number',
                          hintText: 'Enter Contact Number',
                          maxLength: 10,
                          inputType: TextInputType.phone,
                          autoValidateMode: AutovalidateMode.disabled,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please enter Contact Number';
                            } else if (val.length < 10) {
                              return 'Please enter valid Contact Number';
                            }
                            return null;
                          },
                        ),
                        // DropdownMenu(
                        //   onSelected: (value) {
                        //     if (value != null) {
                        //       _verifiedBy = value.toString();
                        //     }
                        //   },
                        //   menuStyle: MenuStyle(
                        //     shape: MaterialStateProperty.all(
                        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                        //   ),
                        //   // width: MediaQuery.of(context).size.width * 0.8,
                        //   menuHeight: MediaQuery.of(context).size.height * 0.7,
                        //   label: Text('Verified By', style: TextStyle(fontSize: 16)),
                        //   dropdownMenuEntries: snapshot.data!
                        //       .map((e) => DropdownMenuEntry(
                        //             value: e.userName ?? '',
                        //             label: e.userName ?? 'No Name',
                        //           ))
                        //       .toList(),
                        //   inputDecorationTheme: InputDecorationTheme(
                        //     filled: true,
                        //     fillColor: Colors.grey.shade200,
                        //     // labelText: 'Verified By',
                        //     // helperText: '',
                        //     contentPadding: const EdgeInsets.symmetric(
                        //       horizontal: 15.0,
                        //       vertical: 10.0,
                        //     ),
                        //     border: UnderlineInputBorder(
                        //       borderSide: BorderSide.none,
                        //       // borderRadius: BorderRadius.circular(10.0),
                        //     ),
                        //     enabledBorder: UnderlineInputBorder(
                        //       borderSide: BorderSide.none,
                        //       // borderRadius: BorderRadius.circular(10.0),
                        //     ),
                        //   ),
                        // ),
                        DropdownSearch<String>(
                          items: (filter, loadProps) => snapshot.data!.map((e) => e.userName ?? '').toList(),
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                labelText: 'Search',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 10.0,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  // borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  // borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              labelText: 'Verified By',
                              helperText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 10.0,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                // borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                // borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              _verifiedBy = value.toString();
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: bloodRequestController.visibility.value ? () => createBloodRequest() : null,
                            child: Text('Submit'),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
