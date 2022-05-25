import 'package:e_game/widgets/EventDetail.dart';
import 'package:e_game/widgets/GameRules.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/eventProvider.dart';
import 'package:e_game/modals/Event.dart';

class EventsDetailsPage extends StatefulWidget {
  final String eventId;
  const EventsDetailsPage({required this.eventId, Key? key}) : super(key: key);

  @override
  State<EventsDetailsPage> createState() => _EventsDetailsPageState();
}

class _EventsDetailsPageState extends State<EventsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    Event event =
        Provider.of<EventProvider>(context).getEventById(widget.eventId);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color(0xff0e182b),
              expandedHeight: 170,
              title: Text(
                event.eventName,
                style: const TextStyle(fontSize: 20),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: event.eventId,
                  child: Image.network(event.imageUrl,
                      fit: BoxFit.cover,
                      color: Colors.white.withOpacity(0.3),
                      colorBlendMode: BlendMode.modulate),
                ),
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: "Details",
                  ),
                  Tab(
                    text: "Rules",
                  ),
                  Tab(
                    text: "Updates",
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverFillRemaining(
                child: TabBarView(
                  children: [
                    EventDetail(eventId: widget.eventId),
                    const GameRules(),
                    const Center(
                      child: Text(
                        "No Updates",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
