import 'package:e_game/konstants/constants.dart';
import 'package:flutter/material.dart';
import 'package:e_game/widgets/TextAndIcon.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:e_game/modals/Event.dart';

import '../providers/eventProvider.dart';

class EventDetail extends StatelessWidget {
  final String eventId;
  final GameType gType;
  const EventDetail({required this.eventId, required this.gType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd MMM yyyy, hh:mm a');
    Event event = Provider.of<EventProvider>(context).getEventById(eventId,gType);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextAndIcon(
          icon: Icons.videogame_asset_outlined,
          text: "Game - ${event.gameName}",
        ),
        TextAndIcon(
          icon: Icons.map,
          text: "Map - ${event.gameMap}",
        ),
        TextAndIcon(
          icon: Icons.model_training,
          text: "Mode - ${event.gameMode}",
        ),
        TextAndIcon(
          icon: Icons.person,
          text: "Users Registered - ${event.userRegistered.length}/${event.totalSlots}",
        ),
        TextAndIcon(
          icon: Icons.calendar_today,
          text: "Event Time - ${f.format(event.eventTime)}",
        ),
        TextAndIcon(
          icon: Icons.attach_money_outlined,
          text: "Entry Fee - ₹${event.entryFee}",
        ),
        TextAndIcon(
          icon: Icons.monetization_on,
          text: "Winning Amount - ₹${(60*(event.userRegistered.length*event.entryFee)/100)}",
        ),
        const TextAndIcon(
          icon: Icons.calendar_view_day_sharp,
          text:
          "Registration Ends At - \n10th May 2022, 09:00 PM",
        ),
      ],
    );
  }
}
