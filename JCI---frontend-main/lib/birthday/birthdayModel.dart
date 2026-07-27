import 'dart:ui';

// ignore: camel_case_types
class birthdayModel {
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  birthdayModel(
      this.eventName, this.from, this.to, this.background, this.isAllDay);
}
