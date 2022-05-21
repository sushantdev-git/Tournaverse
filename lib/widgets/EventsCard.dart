import 'package:e_game/Pages/EventDetailsPage.dart';
import 'package:e_game/providers/pubgProvider.dart';
import 'package:e_game/widgets/TextAndIcon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:e_game/modals/Event.dart';

class EventCard extends StatelessWidget {
  final String eventId;
  const EventCard({required this.eventId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd MMM yyyy, hh:mm a');
    Event event = Provider.of<PubgProvider>(context).getEventById(eventId);
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventsDetailsPage(
              eventId: eventId,
            ),
          ),
        )
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: 200,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xff0e1f3a),
        ),
        child: Stack(
          children: [
            SizedBox(
                width: double.infinity,
                child: Hero(
                  tag: event.eventId,
                  child: Image.network(
                    event.imageUrl,
                    fit: BoxFit.cover,
                    color: Colors.white.withOpacity(0.4),
                    colorBlendMode: BlendMode.modulate,
                  ),
                )),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  TextAndIcon(icon: Icons.access_time_outlined, text: f.format(event.eventTime)),
                  TextAndIcon(icon: Icons.person_rounded, text: "${event.userRegistered}/${event.totalSlots}"),
                  TextAndIcon(icon: Icons.attach_money_outlined, text: "Entry Fee - ₹${event.entryFee}")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
