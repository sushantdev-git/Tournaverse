import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:e_game/modals/Event.dart';
import 'package:http/http.dart' as http;

class EventProvider extends ChangeNotifier {
  List<Event> eventList = [];

  Future<void> fetchEventList() async {

    print("function called");
    const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IklzaGFudCIsImlhdCI6MTY1MzQxODc1OSwiZXhwIjoxNjUzNDE5OTU5fQ.HEE62J0CmWfnCSopbWSARGVNidmcLtlfMso3OfR5eJA";
    try{
      var pubgEvents = await http.get(Uri.parse("https://e-sports-game.herokuapp.com/events/pubgEvents"), headers: {'Authorization': 'Bearer $token'});

      List<dynamic> data = jsonDecode(pubgEvents.body);

      List<Event> eList = [];

      for(var event in data){
        print(event);
        Event newEvent =  Event(
            eventId: event["_id"],
            entryFee: event["entryFee"],
            eventName: event["eventName"],
            eventTime: DateTime.parse(event["eventTime"]),
            gameName: event["gameName"],
            gameMap: event["gameMap"],
            gameMode: event["gameMode"],
            imageUrl: event["backgroundImage"],
            totalSlots: event["totalSlots"],
            userRegistered: event["userRegistered"]
        );
        eList.add(newEvent);
      }

      print(eList.length);
      eventList = eList;
    }
    catch (e){
      print(e);
    }
  }

  Event getEventById(String id){
    //finding event with given id
    Event event = eventList.firstWhere((e) => e.eventId == id);
    return event;
  }
}
