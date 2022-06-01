import 'package:e_game/konstants/constants.dart';
import 'package:e_game/modals/Event.dart';
import 'package:e_game/providers/authProvider.dart';
import 'package:e_game/providers/eventProvider.dart';
import 'package:e_game/widgets/EventsCard.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../konstants/ThemeConstants.dart';
import '../widgets/createAndUpdateEvent.dart';

class EventsPage extends StatefulWidget {
  final String imageUrl;
  final String name;
  final GameType gType;
  const EventsPage(
      {required this.imageUrl,
      required this.name,
      required this.gType,
      Key? key})
      : super(
          key: key,
        );

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool _isLoading = false;
  bool isInit = true;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      EventProvider eventProvider =
          Provider.of<EventProvider>(context, listen: false);
      if (mounted && eventProvider.getEventList(widget.gType).isEmpty) {
        //if the eventList is empty then only we want to show the loading progress else we don't
        setState(() {
          _isLoading = true;
        });
      }
      await eventProvider.fetchEventList(widget.gType).then((value) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Event> eList =
        Provider.of<EventProvider>(context).getEventList(widget.gType);

    return Scaffold(
      floatingActionButton: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return (auth.type == UserType.manager || auth.type == UserType.admin)
              ? FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => CreateAndUpdateEventForm(
                              gType: widget.gType,
                              eventId: null,
                            ));
                  },
                  backgroundColor: primaryColor,
                  elevation: 10,
                  child: const Icon(Icons.add),
                )
              : Container();
        },
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xff0e182b),
            expandedHeight: 170,
            title: Text(
              widget.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.name,
                child: Image.asset(widget.imageUrl,
                    fit: BoxFit.cover,
                    color: Colors.white.withOpacity(0.5),
                    colorBlendMode: BlendMode.modulate),
              ),
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 35),
            sliver: _isLoading
                ? const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  )
                : eList.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            "No event available at the moment",
                            style: whiteTextTheme,
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return EventCard(
                              eventId: eList[index].eventId,
                              gType: widget.gType,
                            );
                          },
                          childCount: eList.length,
                        ),
                      ),
          )
        ],
      ),
    );
  }
}
