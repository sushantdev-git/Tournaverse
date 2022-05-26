import 'dart:convert';
import 'package:e_game/konstants/constants.dart';
import 'package:e_game/providers/authProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:e_game/modals/Event.dart';
import 'package:http/http.dart' as http;

class EventProvider extends ChangeNotifier {
  List<Event> pubgEventList = [];
  List<Event> freeFireEventList = [];
  List<Event> codEventList = [];

  String getEventEndPoint(GameType gType) {
    if (gType == GameType.battlegound) return "pubgEvents";
    if (gType == GameType.freefire) return "freefireEvents";
    return "codEvents";
  }

  void setEventList(GameType gType, List<Event> events) {
    if (gType == GameType.battlegound) {
      pubgEventList = events;
    } else if (gType == GameType.freefire) {
      freeFireEventList = events;
    } else {
      codEventList = events;
    }
  }

  List<Event> getEventList(GameType gType) {
    if (gType == GameType.battlegound) {
      return pubgEventList;
    } else if (gType == GameType.freefire) {
      return freeFireEventList;
    } else {
      return codEventList;
    }
  }

  Future<void> fetchEventList(AuthProvider authProvider, GameType gType) async {
    try {
      var response = await http.get(
        Uri.parse(
          "https://e-sports-game.herokuapp.com/events/${getEventEndPoint(gType)}",
        ),
        headers: {
          'Authorization': 'Bearer ${authProvider.accessToken}',
        },
      );

      if (response.statusCode == 403) {
        //refreshing access Token;
        if (await authProvider.fetchAccessToken()) {
          //if we were able to fetch access token then we will again fetch the request.
          return await fetchEventList(authProvider, gType);
        }
      }

      List<dynamic> data = jsonDecode(response.body);

      List<Event> eList = [];

      for (var event in data) {
        Event newEvent = Event(
            eventId: event["_id"],
            entryFee: event["entryFee"],
            eventName: event["eventName"],
            eventTime: DateTime.parse(event["eventTime"]),
            gameName: event["gameName"],
            gameMap: event["gameMap"],
            gameMode: event["gameMode"],
            imageUrl: event["backgroundImage"],
            totalSlots: event["totalSlots"],
            userRegistered: event["userRegistered"]);
        eList.add(newEvent);
      }
      setEventList(gType, eList);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Event getEventById(String id, GameType gType) {
    //finding event with given id
    List<Event> eventList = getEventList(gType);
    Event event = eventList.firstWhere((e) => e.eventId == id);
    return event;
  }
}
