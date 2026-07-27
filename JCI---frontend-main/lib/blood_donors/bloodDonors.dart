import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jci/controllers/blood_request_controller.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/models/blood_request_model.dart';
import 'package:jci/models/donorsModel.dart';
import 'package:jci/services/bloodDonorService.dart';
import 'package:jci/utils/responsive.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/common.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/referral/widgets/referral_theme.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodDonors extends StatefulWidget {
  const BloodDonors({Key? key}) : super(key: key);

  @override
  _BloodDonorsState createState() => _BloodDonorsState();
}

class _BloodDonorsState extends State<BloodDonors> {
  String selectedGroup = "empty";

  List<donorsModel> _filteredList = [];
  static List<donorsModel> _donorsList = [];
  double _spacing = 8.0;
  BloodRequestController _bloodRequestController = Get.put(BloodRequestController());
  List<BloodRequestInfo?> _bloodRequestList = [];
  Future<List<BloodRequestInfo?>> _bloodRequests = Future.value([]);
  Future<List<donorsModel>> _donorsFuture = Future.value([]);

  Future<List<BloodRequestInfo?>> _getBloodRequests() async {
    await _bloodRequestController.getBloodRequests();
    if (_bloodRequestController.status.value != 1) {
      Get.snackbar(
        'Error',
        _bloodRequestController.responseMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      return [];
    }
    _bloodRequests = Future.value(_bloodRequestController.requestList.data?.info ?? []);
    return _bloodRequestController.requestList.data?.info ?? [];
  }

  @override
  void initState() {
    super.initState();
    _bloodRequests = _getBloodRequests();
    _donorsFuture = DonorsService.getDonorsList();
    setDonorList();
  }

  setDonorList() async {
    _donorsList = await DonorsService.getDonorsList();
  }

  final SponsorController sponsorController = Get.put(SponsorController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustAppBar(Titles.bloodDonors,
            bottom: TabBar(
              labelColor: ReferralTheme.darkBlue,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: ReferralTheme.lightBlue,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Requests'),
                Tab(text: 'Donors'),
              ],
              labelStyle: const TextStyle(
                fontSize: 15,
                fontFamily: 'pop-semibold',
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontFamily: 'pop-reg',
              ),
            )).initAppBar(),
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: ReferralTheme.lightBlue,
          onPressed: () => Get.toNamed('/blood-request'),
          child: const Icon(Icons.add, size: 22, color: Colors.white),
        ),
        body: Responsive.body(
          context,
          TabBarView(
          children: [
            FutureBuilder(
              future: _bloodRequests,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    _bloodRequestList = snapshot.data as List<BloodRequestInfo?>;
                    return Obx(() {
                      final showCopy = sponsorController.getCopyVisible;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await _getBloodRequests();
                            setState(() {});
                          },
                          child: _bloodRequestList.isNotEmpty
                              ? ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 80),
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: _bloodRequestList.length,
                                  itemBuilder: (context, index) {
                                    final info = _bloodRequestList[index] ?? BloodRequestInfo();
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: BloodRequestCard(
                                        key: ValueKey(info.id ?? index),
                                        spacing: _spacing,
                                        info: info,
                                        showCopy: showCopy,
                                      ),
                                    );
                                  },
                                )
                              : ListView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  children: const [
                                    SizedBox(height: 48),
                                    Center(child: Text('No Blood Requests Found!')),
                                  ],
                                ),
                        ),
                      );
                    });
                  default:
                    return Center(child: Text('Something went wrong!'));
                }
              },
            ),
            FutureBuilder(
              future: _donorsFuture,
              builder: (BuildContext ctx, AsyncSnapshot<List<donorsModel>> snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: Responsive.listPadding(context, bottom: 12),
                            itemCount: (selectedGroup == "empty")
                                ? snapshot.data?.length
                                : _filteredList.length,
                            itemBuilder: (ctx, index) {
                              var mem = (selectedGroup == "empty")
                                  ? snapshot.data![index]
                                  : _filteredList[index];
                              if (index == 0) {
                                return _header();
                              }
                              return MemberCard(
                                compact: true,
                                image: mem.img,
                                name: mem.name,
                                phone: mem.phone,
                                role: mem.title,
                                onTap: () => Get.toNamed('/profile', arguments: [mem.id]),
                              );
                            },
                          ),
                        ),
                        _space(10),
                        Visibility(
                            visible: sponsorController.getMainSponsorVisiblity(),
                            child: SponsorData.sponserTitle("${JciString.powered_by}")),
                        _space(10),
                        SponsorData.mainSponsor(context),
                        _space(10)
                      ],
                    );
                  }
                }
              },
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: Utils.darkBlue,
      height: 168,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                _bloodGroup('A+'),
                _bloodGroup('B+'),
                _bloodGroup('O+'),
                _bloodGroup('AB+'),
                _bloodGroup('A1+'),
                _bloodGroup('A1B+'),
                _bloodGroup('A2B+'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _bloodGroup('A-'),
                _bloodGroup('B-'),
                _bloodGroup('O-'),
                _bloodGroup('AB-'),
                _bloodGroup('A2+'),
                _bloodGroup('A1B-'),
                _bloodGroup('A2B-'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bloodGroup(String type) {
    final selected = selectedGroup == type;
    return InkWell(
      onTap: () {
        setState(() {
          selectedGroup = type;
          filterMember(selectedGroup);
        });
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.center,
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: selected ? const Color(0xff24B9EC) : Colors.white,
          shape: BoxShape.circle,
        ),
        child: Text(
          type,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontSize: 13,
            fontFamily: 'pop-semibold',
          ),
        ),
      ),
    );
  }

  void filterMember(var bloodGroup) {
    _filteredList.clear();

    _filteredList.add(donorsModel(id: "", img: "", name: "", title: "", phone: "", blood: ""));

    for (var _mem in _donorsList) {
      if (_mem.blood == bloodGroup) {
        _filteredList.add(_mem);
      }
    }
  }

  Widget _space(double h) {
    return SizedBox(height: h);
  }
}

class BloodRequestCard extends StatefulWidget {
  const BloodRequestCard({
    super.key,
    required this.spacing,
    required this.info,
    required this.showCopy,
  });

  final double spacing;
  final BloodRequestInfo info;
  final bool showCopy;

  @override
  State<BloodRequestCard> createState() => _BloodRequestCardState();
}

class _BloodRequestCardState extends State<BloodRequestCard> {
  final GlobalKey _repaintKey = GlobalKey();
  final SponsorController _sponsorController = Get.find<SponsorController>();

  Future<void> _shareRequest() async {
    final info = widget.info;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating Image...')),
    );
    await _sponsorController.setCopyVisible(false);
    await Future.delayed(const Duration(milliseconds: 100));
  if (!mounted || _repaintKey.currentContext == null) {
      await _sponsorController.setCopyVisible(true);
      return;
    }

    final text = '\u{1FA78} Blood Request \u{1FA78}\n\n'
        'Name: ${info.nameOfPatient}\n'
        'Blood Group: ${info.bloodGroup}\n'
        'No. of Units: ${info.noOfUnits}\n'
        'Hospital: ${info.hospitalName}\n'
        'Location: ${info.location}\n'
        'Attender: ${info.attender}\n'
        'Contact: +91${info.contact}\n'
        'Created At: ${info.createdAt}\n'
        'Verified By: ${info.verifiedBy}\n\n'
        'Share this request with your friends and family to help the patient in need.\n\n'
        'Powered by JCI Erode Greencity';

    final boundary = _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      await _sponsorController.setCopyVisible(true);
      return;
    }
    final tempDirectory = (await getTemporaryDirectory()).path;
    final file = File('$tempDirectory/request_${info.id ?? DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    await Share.shareXFiles([XFile(file.path)], text: text);
    await _sponsorController.setCopyVisible(true);
  }

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontFamily: 'pop-semibold',
      fontSize: 15,
      color: Color(0xFF111827),
    );
    const bodyStyle = TextStyle(
      fontFamily: 'pop-reg',
      fontSize: 13,
      color: Color(0xFF4B5563),
    );
    const iconSize = 18.0;

    return Card(
      elevation: 0,
      shadowColor: Color(0xff23346B),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 0.25),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: RepaintBoundary(
        key: _repaintKey,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: Icon(
                  Icons.water_drop_rounded,
                  size: 90,
                  color: Colors.red.shade100,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.badge_outlined, size: iconSize, color: Color(0xff23346B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.info.nameOfPatient ?? 'Patient Name',
                          maxLines: 2,
                          style: titleStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.spacing),
                  Row(
                    children: [
                      const Icon(Icons.bloodtype_outlined, size: iconSize, color: Color(0xff23346B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.info.bloodGroup ?? 'Blood Group', maxLines: 1, style: bodyStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.spacing),
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: iconSize, color: Color(0xff23346B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('${widget.info.noOfUnits ?? '--'} Units', maxLines: 1, style: bodyStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.spacing),
                  Row(
                    children: [
                      const Icon(Icons.local_hospital_outlined, size: iconSize, color: Color(0xff23346B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.info.hospitalName ?? 'Hospital Name', maxLines: 2, style: bodyStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.spacing),
                  Row(
                    children: [
                      const Icon(Icons.location_searching_outlined, size: iconSize, color: Color(0xff23346B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.info.location ?? 'Hospital Location', maxLines: 4, style: bodyStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.spacing),
                  Row(
                    children: [
                      const Icon(Icons.person_outlined, size: iconSize, color: Color(0xff23346B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.info.attender ?? 'Attender name', maxLines: 2, style: bodyStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.spacing),
                  Row(
                    children: [
                      const Icon(Icons.call_outlined, size: iconSize, color: Color(0xff23346B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('+91${widget.info.contact ?? '--'}', maxLines: 1, style: bodyStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.spacing),
                  Row(
                    children: [
                      const Icon(Icons.verified_outlined, size: iconSize, color: Color(0xff23346B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.info.verifiedBy ?? 'Verified By', maxLines: 2, style: bodyStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.spacing),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: iconSize, color: Color(0xff23346B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.info.createdAt ?? 'Created Time', maxLines: 2, style: bodyStyle),
                      ),
                    ],
                  ),
                ],
              ),
              if (widget.showCopy)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Column(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        iconSize: 20,
                        onPressed: _shareRequest,
                        icon: const Icon(Icons.share),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        iconSize: 20,
                        icon: const Icon(Icons.call_outlined),
                        onPressed: () async {
                          if (widget.info.contact != null) {
                            final url = Uri(scheme: 'tel', path: '+91${widget.info.contact}');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              Get.snackbar('Error!', 'Error opening dialer');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
