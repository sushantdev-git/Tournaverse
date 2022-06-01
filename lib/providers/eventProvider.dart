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

  bool isLoading = false;
  String getEventEndPoint(GameType gType) {
    if (gType == GameType.battlegound) return "pubgEvents";
    if (gType == GameType.freefire) return "freefireEvents";
    return "codEvents";
  }

  final AuthProvider _api;

  EventProvider(this._api);

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
    } else if(gType == GameType.cod){
      return codEventList;
    }
    else{
      return _api.eventsParticipated;
    }
  }

  Future<void> fetchEventList(GameType gType) async {
    if(gType == GameType.myEvent) return; //if this is myEvent page then we don't have to fetch it
    try {
      http.Response response = await _api.get(
          endPoint: "events/${getEventEndPoint(gType)}", retry: false);

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
          userRegistered: event["userRegistered"],
          creatorId: event["creator"]["userId"],
          creatorName: event["creator"]["username"],
        );
        eList.add(newEvent);
      }
      setEventList(gType, eList);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Event getEventById(String? id, GameType gType) {
    //finding event with given id
    List<Event> eventList = getEventList(gType);
    for (Event e in eventList) {
      if (e.eventId == id) return e;
    }
    return Event(
      eventId: "randomString1233",
      entryFee: 50,
      eventName: "Not found event",
      eventTime: DateTime.now(),
      gameName: "Battleground",
      gameMap: "Erangle",
      gameMode: "FPP",
      imageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTD-_y_GWqOa1xLPPUJKSjQCQ1RZe6KXhsP9g&usqp=CAU",
      totalSlots: 20,
      userRegistered: [1, 2, 3],
      creatorId: "random",
      creatorName: "random"
    );
  }

  Future<int> postNewEvent({
    required String eventName,
    required String gameMap,
    required String gameMode,
    required String bgImageUrl,
    required int totalSlots,
    required int entryFee,
    required int winningAmount,
    required DateTime datetime,
    required String gameName,
    required bool eventStatus,
  }) async {
    isLoading = true;
    notifyListeners();

    http.Response res = await _api.post(
      endPoint: "events/createEvent/",
      body: {
        "eventName": eventName,
        "gameMap": gameMap,
        "gameMode": gameMode,
        "imageUrl": bgImageUrl,
        "totalSlots": totalSlots.toString(),
        "entryFee": entryFee.toString(),
        "winningAmount": winningAmount.toString(),
        "eventTime": datetime.toString(),
        "gameName": gameName,
        "creatorId": _api.userId,
        "creatorName": _api.username,
        "eventStatus": eventStatus ? "approved" : "pending",
      },
    );

    isLoading = false;
    notifyListeners();
    return res.statusCode;
  }

  bool isParticipated(String eventId, GameType gType){
    String userId = _api.userId;
    List<Event> eList = getEventList(gType);
    Event event = eList.firstWhere((e) => e.eventId == eventId);

    for(var user in event.userRegistered){
      if(user["user"]["_id"] == userId) return true;
    }

    return false;
  }
}
