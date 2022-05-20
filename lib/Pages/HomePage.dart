import 'package:flutter/material.dart';
import 'package:e_game/widgets/GameCard.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 70),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.brown.shade800,
                  child: const Text('S'),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Text(
                    "Sushant",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: const Text(
                "Games",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            GameCard(),
            GameCard(),
            GameCard(),
            GameCard(),
            GameCard(),
          ],
        ),
      ),
    );
  }
}
