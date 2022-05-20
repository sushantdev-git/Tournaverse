import 'package:e_game/widgets/GameCard.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  final String imageUrl;
  final String name;
  const EventsPage({required this.imageUrl, required this.name,  Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color(0xff0e182b),
              expandedHeight: 170,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(name, style: TextStyle(fontSize: 15),),
                background: Hero(
                  tag: name,
                  child: Image.asset(imageUrl, fit: BoxFit.cover, color: Colors.white.withOpacity(0.6), colorBlendMode: BlendMode.modulate),
                )
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(15),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return const GameCard(name: "PUBG", imageUrl: "assets/images/pubg.jpg");
                  },
                  childCount: 1,
                ),
              ),
            )
          ],
      ),
    );
  }
}
