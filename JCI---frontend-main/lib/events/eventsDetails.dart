import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jci/controllers/eventDetailsController.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/scroll_to_end_fab.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:lottie/lottie.dart';

class EventsDetails extends StatefulWidget {
  @override
  _EventsDetailsState createState() => _EventsDetailsState();
}

class _EventsDetailsState extends State<EventsDetails> {
  final String u = dotenv.get('URL');
  final List<String> id = Get.arguments;
  final _eventController = Get.put(EventDetailController());
  final _visibleController = Get.put(SponsorController());
  final _scrollController = ScrollController();

  static const _titleStyle = TextStyle(
    fontFamily: 'pop-semibold',
    fontSize: 17,
    color: Color(0xFF111827),
    height: 1.35,
  );

  static final _bodyStyle = TextStyle(
    fontFamily: 'pop-reg',
    fontSize: 14,
    height: 1.55,
    color: Colors.grey.shade800,
  );

  static final _metaStyle = TextStyle(
    fontFamily: 'pop-reg',
    fontSize: 14,
    color: Colors.grey.shade800,
    height: 1.4,
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<String>> _getEventImageData() async {
    final url = Uri.parse('$u/member/event_image');
    final img = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id[0]}),
    );
    final responseData = json.decode(img.body);
    final imgList = <String>[];
    for (final item in responseData['response']['data']['info']) {
      imgList.add(item['event_image']);
    }
    return imgList;
  }

  Future<List<EventDetailsModel>> _getEventDetails() async {
    final url = Uri.parse('$u/member/event');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id[0]}),
    );
    final responseData = json.decode(response.body);
    final data = responseData['response']['data']['info'];
    return [
      EventDetailsModel(
        image: data['event_image'],
        title: data['event_name'],
        time: data['event_time'],
        date: data['event_date'],
        location: data['event_location'],
        desc: data['event_desc'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(Titles.eventDetails).initAppBar(),
      floatingActionButton: ScrollToEndFab(controller: _scrollController),
      body: SafeArea(
        child: FutureBuilder(
          future: _getEventDetails(),
          builder: (BuildContext ctx, AsyncSnapshot<List<EventDetailsModel>> snapshot) {
            if (snapshot.data == null && snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: MediaQuery.of(ctx).size.height / 1.2,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.connectionState == ConnectionState.done && snapshot.data == null) {
              return _nodatafound();
            }
            if (snapshot.data!.isEmpty) return _nodatafound();

            final event = snapshot.data![0];
            return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _poster(context, event.image),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Text(caps(event.title), style: _titleStyle),
                  ),
                  _eventPlace('${event.date}, ${event.time}', event.location),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Text(
                      caps(event.desc),
                      style: _bodyStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: _eventController.getVisible(),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                        child: Text('Photos', style: _titleStyle),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: _getEventImageData(),
                    builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data.isEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _eventController.setVisible(false);
                        });
                        return const SizedBox.shrink();
                      }
                      return CarouselSlider.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () => Get.toNamed('/imgView', arguments: [snapshot.data[itemIndex]]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  snapshot.data[itemIndex],
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  errorBuilder: (_, __, ___) => Container(),
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 220,
                          enlargeCenterPage: true,
                          initialPage: 0,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: _visibleController.getMainSponsorVisiblity(),
                    child: Center(child: SponsorData.sponserTitle(JciString.powered_by)),
                  ),
                  const SizedBox(height: 10),
                  Center(child: SponsorData.mainSponsor(context)),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Center _nodatafound() {
    return Center(child: Lottie.asset('assets/lottie/no_data.json'));
  }

  Widget _poster(BuildContext ctx, String image) {
    return InkWell(
      onTap: () => Get.toNamed('/imgView', arguments: [image]),
      child: Image.network(
        image,
        width: MediaQuery.of(ctx).size.width,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(),
      ),
    );
  }

  Widget _eventPlace(String date, String location) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _custTile('clock_colored.svg', date),
          const SizedBox(height: 10),
          _custTile('location.svg', location),
        ],
      ),
    );
  }

  Widget _custTile(String icon, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/icons/$icon', width: 16, height: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            caps(title),
            style: _metaStyle,
          ),
        ),
      ],
    );
  }
}

class EventDetailsModel {
  String image, title, date, time, location, desc;

  EventDetailsModel({
    required this.image,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.desc,
  });
}
