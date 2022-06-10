import 'package:e_game/Pages/EventDetailsPage.dart';
import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:e_game/konstants/constants.dart';
import 'package:e_game/pageRouterBuilder/CustomPageRouteBuilder.dart';
import 'package:e_game/providers/authProvider.dart';
import 'package:e_game/providers/eventProvider.dart';
import 'package:e_game/widgets/TextAndIcon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:e_game/modals/Event.dart';

class EventCard extends StatelessWidget {
  final String eventId;
  final GameType gType;
  const EventCard({required this.eventId, required this.gType, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd MMM yyyy, hh:mm a');
    Event event =
        Provider.of<EventProvider>(context).getEventById(eventId, gType);
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 215,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xff0e1f3a),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.black12,
          splashColor: Colors.black26,
          onTap: () => {
            Navigator.of(context).push(
              CustomPageRoute(
                child: EventsDetailsPage(
                  eventId: eventId,
                  gType: gType,
                ),
              ),
            )
          },
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 215,
                child: Image.network(
                  event.imageUrl,
                  fit: BoxFit.cover,
                  color: Colors.white.withOpacity(0.4),
                  colorBlendMode: BlendMode.modulate,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.eventName, style: medtext.bodyText1),
                    TextAndIcon(
                        icon: Icons.access_time_outlined,
                        text: f.format(event.eventTime)),
                    TextAndIcon(
                        icon: Icons.person_rounded,
                        text:
                            "${event.userRegistered.length}/${event.totalSlots}"),
                    TextAndIcon(
                        icon: Icons.attach_money_outlined,
                        text: "Entry Fee - ₹${event.entryFee}"),
                    // Expanded(child: Container()),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       if (auth.userId == event.creatorId ||
                    //           auth.type == UserType.admin)
                    //         ModifiedIconButton(
                    //           onPress: () {
                    //             showModalBottomSheet(
                    //               isScrollControlled: true,
                    //               backgroundColor: Colors.transparent,
                    //               context: context,
                    //               builder: (context) {
                    //                 return CreateAndUpdateEventForm(
                    //                   gType: gType,
                    //                   eventId: event.eventId,
                    //                 );
                    //               },
                    //             );
                    //           },
                    //           icon: Icons.edit,
                    //         ),
                    //       if (auth.type == UserType.admin)
                    //         ModifiedIconButton(
                    //           onPress: () {},
                    //           icon: Icons.delete,
                    //         ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ModifiedIconButton extends StatelessWidget {
  final Function onPress;
  final IconData icon;
  const ModifiedIconButton(
      {required this.onPress, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onPress(),
      icon: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: primaryColor,
        ),
      ),
    );
  }
}
