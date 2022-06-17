import 'package:e_game/konstants/constants.dart';
import 'package:e_game/providers/eventProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:e_game/modals/Event.dart';

import '../konstants/ThemeConstants.dart';
import 'dateTimePicker.dart';

class CreateAndUpdateEventForm extends StatefulWidget {
  final GameType gType;
  final String? eventId;
  const CreateAndUpdateEventForm(
      {required this.gType, required this.eventId, Key? key})
      : super(key: key);

  @override
  State<CreateAndUpdateEventForm> createState() =>
      _CreateAndUpdateEventFormState();
}

class _CreateAndUpdateEventFormState extends State<CreateAndUpdateEventForm> {
  //state variables
  String eventName = "";
  String gameMap = "";
  String gameMode = "";
  String totalSlots = "";
  String entryFee = "";
  String winningAmount = "";
  String bgImageUrl = "";
  bool acceptPayment = false;

  DateTime dateTime = DateTime.now();

  //validators
  final _formKey = GlobalKey<FormState>();

  //functions
  Future<void> handleCreateEvent(context) async {
    EventProvider eP = Provider.of<EventProvider>(context, listen: false);
    int sc = await eP.postNewEvent(
      eventName: eventName.trim(),
      gameMap: gameMap.trim(),
      gameMode: gameMode.trim(),
      bgImageUrl: bgImageUrl.trim(),
      totalSlots: int.parse(totalSlots.trim()),
      entryFee: int.parse(totalSlots.trim()),
      winningAmount: int.parse(totalSlots.trim()),
      datetime: dateTime,
      gameName: getGameName(widget.gType),
      eventStatus: acceptPayment,
    );
    if (sc == 200) {
      Navigator.of(context).pop();
      await eP.fetchEventList(widget.gType);
    }
  }

  @override
  initState() {
    if (widget.eventId != null) {
      Event event = Provider.of<EventProvider>(context, listen: false)
          .getEventById(widget.eventId, widget.gType);
      eventName = event.eventName;
      gameMap = event.gameMap;
      gameMode = event.gameMode;
      bgImageUrl = event.imageUrl;
      totalSlots = event.totalSlots.toString();
      dateTime = event.eventTime;
      entryFee = event.entryFee.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final f = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DraggableScrollableSheet(
        maxChildSize: 0.8,
        initialChildSize: 0.8,
        minChildSize: 0.5,
        builder: (context, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xff171D2F),
            ),
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: isKeyboardVisible ? 0 : 20,
            ),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              controller: controller,
              children: [
                Text(
                  "${widget.eventId != null ? "Update" : "Create"} Event",
                  style: whiteTextThemeHeader,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: eventName,
                        style: whiteTextTheme,
                        cursorColor: Colors.white,
                        decoration: getInputDecoration("Enter event Name"),
                        onChanged: (val) => eventName = val,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter event name";
                          }
                          val = val.trim();
                          if (val.length < 5) {
                            return "Minimum length should be 5";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: gameMap,
                        style: whiteTextTheme,
                        cursorColor: Colors.white,
                        decoration: getInputDecoration("Enter game map"),
                        onChanged: (val) => gameMap = val,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter game map";
                          }
                          val = val.trim();
                          if (val.length < 5) {
                            return "Minimum length should be 5";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: gameMode,
                        style: whiteTextTheme,
                        cursorColor: Colors.white,
                        decoration: getInputDecoration("Enter game mode"),
                        onChanged: (val) => gameMode = val,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter game mode";
                          }
                          val = val.trim();
                          if (val.length < 3) {
                            return "Minimum length should be 3";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: totalSlots.toString(),
                        style: whiteTextTheme,
                        cursorColor: Colors.white,
                        decoration: getInputDecoration("Enter total Slots"),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => totalSlots = val,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter total slots";
                          }
                          val = val.trim();
                          int x = int.parse(val);
                          if (x > 100) return "Enter a valid no of slots";
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: entryFee.toString(),
                        style: whiteTextTheme,
                        cursorColor: Colors.white,
                        decoration: getInputDecoration("Enter entry fee"),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => entryFee = val,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter entry fee";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: winningAmount.toString(),
                        style: whiteTextTheme,
                        cursorColor: Colors.white,
                        decoration: getInputDecoration("Enter winning amount"),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => winningAmount = val,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter winning amount";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: bgImageUrl,
                        style: whiteTextTheme,
                        cursorColor: Colors.white,
                        decoration:
                            getInputDecoration("Enter background image URL"),
                        onChanged: (val) => bgImageUrl = val,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter background image URL";
                          }
                          val = val.trim();
                          if (!val.startsWith("https:/")) {
                            return "Enter a valid imager Url";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Start accepting payment for this event.",
                            style: whiteTextTheme,
                          ),
                          Switch(
                            value: acceptPayment,
                            activeColor: primaryColor,
                            onChanged: (val) => setState(() {
                              acceptPayment = val;
                            }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    var d = await pickDateTime(context);
                    setState(() {
                      dateTime = d;
                    });
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: Center(
                      child: Text(
                        "Pick Date and Time \n\n${f.format(dateTime)}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Consumer<EventProvider>(
                  builder: (context, eventP, _) {
                    return eventP.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                handleCreateEvent(context);
                              }
                            },
                            child: const SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                child: Text("Create"),
                              ),
                            ),
                          );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
