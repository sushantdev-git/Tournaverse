import 'package:e_game/Pages/LoginPage.dart';
import 'package:e_game/Pages/Profile.dart';
import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:e_game/konstants/constants.dart';
import 'package:e_game/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:e_game/widgets/GameCard.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currPageIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff0e182b),
        fixedColor: Colors.white,
        onTap: (val){
          setState((){
            currPageIndex = val;
          });
        },
        currentIndex: currPageIndex,
        unselectedItemColor: Colors.white30,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 60),
        physics: const BouncingScrollPhysics(),
        child: currPageIndex == 0 ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xff182a4c),
                  child: Text('S'),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Consumer<AuthProvider>(
                    builder: (ctx, _auth, _){
                      return Text(
                        "Welcome, ${_auth.username}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      );
                    }
                  )
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const GameCard(name: "BattleGround", imageUrl: "assets/images/pubg.jpg", gType: GameType.battlegound,),
            const GameCard(name: "FreeFire", imageUrl: "assets/images/freeFire.jpg", gType: GameType.freefire,),
            const GameCard(name: "Call of Duty", imageUrl: "assets/images/cod.jpg", gType: GameType.cod,),
          ],
        ) : const ProfilePage(),
      ),
    );
  }
}
