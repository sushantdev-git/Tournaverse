import 'package:e_game/konstants/ThemeConstants.dart';
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
  final Function onTap;
  const EventDetail({
    required this.eventId,
    required this.gType,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  bool canRegister(EventProvider eP, Event event){
    //this function checking if there is any chance that user can register.
    if(DateTime.now().compareTo(event.eventTime.subtract(const Duration(hours: 6))) >= 0) return false;
    if(eP.isParticipated(eventId, gType)) return false;
    if(event.userRegistered.length >= event.totalSlots) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd MMM yyyy, hh:mm a');
    EventProvider ep = Provider.of<EventProvider>(context);
    Event event = ep.getEventById(eventId, gType);
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
          text:
              "Users Registered - ${event.userRegistered.length}/${event.totalSlots}",
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
          text:
              "Winning Amount - ₹${(60 * (event.userRegistered.length * event.entryFee) / 100)}",
        ),
        TextAndIcon(
          icon: Icons.calendar_view_day_sharp,
          text: "Registration Ends At - \n${f.format(event.eventTime.subtract(const Duration(hours: 6)))}",
        ),
        const SizedBox(
          height: 100,
        ),
        ElevatedButton(
          onPressed: canRegister(ep, event)? () {
                  showModalBottomSheet(
                    backgroundColor: scaffoldColor,
                    elevation: 5,
                    context: context,
                    builder: (context) => EventRegistrationForm(
                      gType: gType,
                      onTap: onTap,
                    ),
                  );
                }
              : null,
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Center(
              child:
                  Text(ep.isParticipated(eventId, gType) ? "Registered" : "Register"),
            ),
          ),
        ),
      ],
    );
  }
}

class EventRegistrationForm extends StatefulWidget {
  const EventRegistrationForm(
      {required this.gType, required this.onTap, Key? key})
      : super(key: key);

  final GameType gType;
  final Function onTap;
  @override
  State<EventRegistrationForm> createState() => _EventRegistrationFormState();
}

class _EventRegistrationFormState extends State<EventRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  late String gameId;
  bool checkboxVal = false;
  bool loading = false;

  String gameName(GameType gType) {
    if (gType == GameType.battlegound) return "Battleground";
    if (gType == GameType.freefire) return "Freefire";
    return "COD Mobile";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff171D2F),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("Event Registration", style: whiteTextThemeHeader),
          const SizedBox(
            height: 50,
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: getInputDecoration(
                        "Enter you ${gameName(widget.gType)} Id"),
                    style: whiteTextTheme,
                    cursorColor: Colors.white,
                    onChanged: (val) => gameId = val,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CheckboxListTile(
                    value: checkboxVal,
                    onChanged: (val) {
                      setState(() {
                        checkboxVal = val!;
                      });
                    },
                    activeColor: primaryColor,
                    title: const Text(
                      "I agree to all the rules provide in rules section",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    subtitle: const Text(
                      "Please read all the rules before registering for event!!",
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    tileColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  )
                ],
              )),
          const SizedBox(
            height: 80,
          ),
          loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : ElevatedButton(
                  onPressed: checkboxVal
                      ? () async {
                          setState(() {
                            loading = true;
                          });
                          await widget.onTap(context, gameId);
                          Navigator.of(this.context).pop();
                        }
                      : null,
                  child: const SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text("Pay"),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
