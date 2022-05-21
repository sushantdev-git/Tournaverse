import 'package:flutter/material.dart';
import 'package:e_game/widgets/TextAndIcon.dart';

class GameRules extends StatelessWidget {
  const GameRules({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        TextAndIcon(
          icon: Icons.monetization_on_rounded,
          text: "Winning amount may vary according to user participated in the game.",
        ),
        TextAndIcon(
          icon: Icons.cancel,
          text: "Once you have registered in event, the money will not be refunded.",
        ),
        TextAndIcon(
          icon: Icons.timelapse,
          text: "If you not entered in game on time, then no one is responsible for it.\n(You can't ask for refund)",
        ),
      ],
    );
  }
}
