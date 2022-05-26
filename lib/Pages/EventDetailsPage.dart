import 'package:e_game/konstants/constants.dart';
import 'package:e_game/widgets/EventDetail.dart';
import 'package:e_game/widgets/GameRules.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/eventProvider.dart';
import 'package:e_game/modals/Event.dart';

class EventsDetailsPage extends StatefulWidget {
  final String eventId;
  final GameType gType;
  const EventsDetailsPage({required this.eventId, required this.gType, Key? key}) : super(key: key);

  @override
  State<EventsDetailsPage> createState() => _EventsDetailsPageState();
}

class _EventsDetailsPageState extends State<EventsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    Event event =
        Provider.of<EventProvider>(context).getEventById(widget.eventId, widget.gType);
    List<String> tabName = ["Details", "Rules", "Updates"];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
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
              )
            ];
          },
          body: TabBarView(
            children: tabName.map((name) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>(name),
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverPadding(
                            padding: const EdgeInsets.all(20),
                          sliver: SliverFixedExtentList(
                            itemExtent: name == "Details" ? 500 : name == "Rules" ? 1600 : 1600,
                            delegate: SliverChildListDelegate(
                              [
                                if(name == "Details") EventDetail(eventId: widget.eventId,gType: widget.gType,),
                                if(name == "Rules") const GameRules(),
                                if(name == "Updates") const GameRules()
                              ]
                            ),
                          )
                        )
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
