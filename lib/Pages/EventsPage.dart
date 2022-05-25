import 'package:e_game/modals/Event.dart';
import 'package:e_game/providers/authProvider.dart';
import 'package:e_game/providers/eventProvider.dart';
import 'package:e_game/widgets/EventsCard.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  final String imageUrl;
  final String name;
  const EventsPage({required this.imageUrl, required this.name, Key? key})
      : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    //if this page is loaded we fetch event list from firebase
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    Provider.of<EventProvider>(context).fetchEventList(authProvider).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Event> _eList = Provider.of<EventProvider>(context).eventList;
    return Scaffold(
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
            padding: const EdgeInsets.all(15),
            sliver: _isLoading
                ? const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return EventCard(
                          eventId: _eList[index].eventId,
                        );
                      },
                      childCount: _eList.length,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
