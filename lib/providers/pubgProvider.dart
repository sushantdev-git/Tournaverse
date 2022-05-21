import 'package:flutter/foundation.dart';
import 'package:e_game/modals/Event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PubgProvider extends ChangeNotifier {
  List<Event> eventList = [];

  Future<void> fetchEventList() async {

    try{
      final CollectionReference events =
        FirebaseFirestore.instance.collection('events');
      QuerySnapshot eventsQuery = await events.get();
      List<Event> eList = [];
      for (var e in eventsQuery.docs) {
        Event newEvent = Event(
          entryFee: e["entryFee"],
          eventName: e["eventName"],
          gameName: e["game"],
          eventTime: (e["eventTime"] as Timestamp).toDate(),
          gameMap: e["gameMap"],
          gameMode: e["gameMode"],
          imageUrl: e["backgroundImage"],
          totalSlots: e["totalSlots"],
          userRegistered: e["userRegistered"],
          eventId: e.id,
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
