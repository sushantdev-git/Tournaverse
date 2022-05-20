import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  const GameCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage("https://wallpapercave.com/wp/wp5350825.jpg"),
          fit: BoxFit.cover
        ),
        borderRadius: BorderRadius.circular(15)
      ),
      child: const Text(
        "BattleGround",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
