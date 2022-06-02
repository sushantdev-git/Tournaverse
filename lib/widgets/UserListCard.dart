import 'package:e_game/konstants/constants.dart';
import 'package:flutter/material.dart';


class UserListCard extends StatelessWidget {
  final String username;
  final String userGameId;
  final GameType gType;
  const UserListCard({required this.username, required this.userGameId, required this.gType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xff5300CB),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "${getGameName(gType).toUpperCase()} ID - $userGameId",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }
}
