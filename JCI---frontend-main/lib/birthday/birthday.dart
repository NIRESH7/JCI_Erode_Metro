import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/utils/responsive.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'bDataSource.dart';

class Birthday extends StatefulWidget {
  const Birthday({Key? key}) : super(key: key);

  @override
  _BirthdayState createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  @override
  void initState() {
    super.initState();
    _getBirthdayData();
  }

  var visibleController = Get.put(SponsorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(Titles.birthday).initAppBar(),
      body: Responsive.body(
        context,
        FutureBuilder(
          future: _getBirthdayData(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return Center(
                child: Lottie.asset(
                  "assets/lottie/no_data.json",
                  height: Responsive.screenHeight(context) * 0.3,
                  repeat: true,
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: SfCalendar(
                    view: CalendarView.month,
                    dataSource: MeetingDataSource(snapshot.data),
                    initialSelectedDate: DateTime.now(),
                    showNavigationArrow: true,
                    allowViewNavigation: true,
                    showDatePickerButton: true,
                    monthViewSettings: const MonthViewSettings(
                      showAgenda: true,
                      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                    ),
                  ),
                ),
                _space(12),
                Visibility(
                  visible: visibleController.getMainSponsorVisiblity(),
                  child: SponsorData.sponserTitle("${JciString.powered_by}"),
                ),
                _space(10),
                SponsorData.mainSponsor(context),
                SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<List<Meeting>> _getBirthdayData() async {
    String u = dotenv.get("URL");
    Uri url = Uri.parse("$u/member/dob");
    var _dobresp = await http.get(url);
    var _dobRespData = json.decode(_dobresp.body);
    final List<Meeting> meetings = <Meeting>[];
    for (var _dob in _dobRespData['response']['data']['info']) {
      if (_dob['dob'] == null) {
        continue;
      }
      final String dob = _dob['dob'];
      final List<String> bday = dob.contains("/") ? dob.split('/') : dob.split('-');

      final DateTime startTime =
          DateTime(int.parse(bday[2]), int.parse(bday[1]), int.parse(bday[0]), 10, 0, 0);
      final DateTime endTime = startTime.add(const Duration(hours: 1));
      meetings.add(
        Meeting(
            '${caps(_dob['user_name'])}\'s birthday',
            startTime,
            endTime,
            const Color(0xFF0F8644),
            false,
            'FREQ=YEARLY;BYMONTHDAY=${bday[0]};BYMONTH=${bday[1]};COUNT=100'),
      );
    }

    return meetings;
  }

  Widget _space(double h) {
    return SizedBox(height: h);
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay, this.recurrenceRule);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String recurrenceRule;
}
