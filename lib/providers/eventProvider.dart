import 'dart:convert';

import 'package:e_game/providers/authProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:e_game/modals/Event.dart';
import 'package:http/http.dart' as http;

class EventProvider extends ChangeNotifier {
  List<Event> eventList = [];

  Future<void> fetchEventList(AuthProvider authProvider) async {

    try{
      var response = await http.get(Uri.parse("https://e-sports-game.herokuapp.com/events/pubgEvents"), headers: {'Authorization': 'Bearer ${authProvider.accessToken}'});

      if(response.statusCode == 403){ //refreshing access Token;
        if(await authProvider.fetchAccessToken()){
          //if we were able to fetch access token then we will again fetch the request.
          return await fetchEventList(authProvider);
        }
      }

      List<dynamic> data = jsonDecode(response.body);

      List<Event> eList = [];

      for(var event in data){
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
