import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jci/models/eventsModel.dart';
import 'package:http/http.dart' as http;

class eventService {
  static Future<List<EventsModel>> getEventsData() async {
    try {
      final String u = dotenv.get("URL");
      final Uri url = Uri.parse('$u/member/allevents');
      final response = await http.get(url);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Could not load events (${response.statusCode})');
      }

      final responseData = json.decode(response.body);
      final info = responseData['response']?['data']?['info'];
      if (info is! List) {
        return [];
      }

      final List<EventsModel> eventsList = [];
      for (final event in info) {
        final EventsModel em = EventsModel(
            id: "${event['id'] ?? ''}",
            image: (event['event_image'] ?? '').toString(),
            title: (event['event_name'] ?? '').toString(),
            date: (event['event_date'] ?? '').toString(),
            time: (event['event_time'] ?? '').toString(),
            location: (event['event_location'] ?? '').toString());
        eventsList.add(em);
      }
      return eventsList;
    } on SocketException {
      throw Exception('No internet connection. Please try again.');
    } on FormatException {
      throw Exception('Invalid server response.');
    } catch (_) {
      throw Exception('Unable to load events right now.');
    }
  }
}
