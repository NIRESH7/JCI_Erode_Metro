import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/services/eventService.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/utils/responsive.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/scroll_to_end_fab.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:lottie/lottie.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final _visibleController = Get.put(SponsorController());
  final _scrollController = ScrollController();
  late Future<dynamic> _eventsFuture;

  static const _titleStyle = TextStyle(
    fontFamily: 'pop-semibold',
    fontSize: 15,
    color: Color(0xFF111827),
    height: 1.3,
  );

  static final _metaStyle = TextStyle(
    fontFamily: 'pop-reg',
    fontSize: 13,
    color: Colors.grey.shade700,
  );

  @override
  void initState() {
    super.initState();
    _eventsFuture = eventService.getEventsData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(Titles.event).initAppBar(),
      floatingActionButton: ScrollToEndFab(controller: _scrollController),
      body: SafeArea(
        child: Responsive.body(
          context,
          FutureBuilder(
            future: _eventsFuture,
            builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset('assets/lottie/no_data.json', height: Get.height * 0.3),
                      const SizedBox(height: 8),
                      const Text(
                        'Unable to load events. Check your internet and try again.',
                        style: TextStyle(fontFamily: 'pop-reg', fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final events = (snapshot.data as List?) ?? [];
              if (events.isEmpty) {
                return Center(
                  child: Lottie.asset('assets/lottie/no_data.json', height: Get.height * 0.3),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: events.length,
                itemBuilder: (ctx, index) {
                  if (index == events.length - 1) {
                    return Column(
                      children: [
                        _eventCard(events[index]),
                        const SizedBox(height: 20),
                        Visibility(
                          visible: _visibleController.getMainSponsorVisiblity(),
                          child: SponsorData.sponserTitle(JciString.powered_by),
                        ),
                        const SizedBox(height: 10),
                        SponsorData.mainSponsor(context),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: _visibleController.getVisible(),
                          child: SponsorData.sponserTitle(JciString.co_powered_by),
                        ),
                        SponsorData.otherSponsor(context),
                        const SizedBox(height: 20),
                      ],
                    );
                  }
                  return _eventCard(events[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _eventCard(dynamic event) {
    return GestureDetector(
      onTap: () => Get.toNamed('/eventsdetails', arguments: ['${event.id}']),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        padding: const EdgeInsets.all(12),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                event.image,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 88,
                  height: 88,
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: _titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _metaRow('calendar_colored.svg', event.date)),
                      const SizedBox(width: 8),
                      Expanded(child: _metaRow('clock_colored.svg', event.time)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _metaRow('location.svg', event.location, expanded: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaRow(String icon, String title, {bool expanded = false}) {
    final row = Row(
      children: [
        SvgPicture.asset('assets/icons/$icon', width: 16, height: 16),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            caps(title),
            overflow: TextOverflow.ellipsis,
            style: _metaStyle,
            maxLines: 1,
          ),
        ),
      ],
    );
    return expanded ? row : row;
  }
}
