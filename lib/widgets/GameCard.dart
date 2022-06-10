import 'package:e_game/konstants/constants.dart';
import 'package:e_game/pageRouterBuilder/CustomPageRouteBuilder.dart';
import 'package:flutter/material.dart';
import 'package:e_game/Pages/EventsPage.dart';

class GameCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final GameType gType;
  const GameCard(
      {required this.name,
      required this.imageUrl,
      required this.gType,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 200,
      // padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // color: Colors.greenAccent,
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          )),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => {
            Navigator.of(context).push(CustomPageRoute(
                child: EventsPage(
              name: "$name Events",
              imageUrl: imageUrl,
              gType: gType,
            )))
          },
          splashColor: Colors.black26,
          highlightColor: Colors.black12,
        ),
      ),
    );
  }
}
