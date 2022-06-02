import 'package:e_game/Pages/EventsPage.dart';
import 'package:e_game/Pages/PaymentDetailsPage.dart';
import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:e_game/konstants/constants.dart';
import 'package:e_game/widgets/UserProfileCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pageRouterBuilder/CustomPageRouteBuilder.dart';
import '../providers/authProvider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Profile",
          style: whiteTextThemeHeader,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          auth.currentUser.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        UserProfileCard(
          heading: "My Events",
          subtitle: "See all the events you have participated in",
          image: "assets/images/events.jpeg",
          onTap: () {
            auth.tryAutoLogin();
            Navigator.of(context).push(
              CustomPageRoute(
                child : const EventsPage(
                  imageUrl: "assets/images/events.jpeg",
                  name: "My Events",
                  gType: GameType.myEvent,
                ),
              ),
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
        UserProfileCard(
          heading: "My Payments",
          subtitle: "See you payment history",
          image: "assets/images/wallet.jpeg",
          onTap: (){
            auth.fetchMyPayments();
            Navigator.of(context).push(CustomPageRoute(child: const PaymentDetailsPage()));
          },
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () => {auth.autoLogout()},
          child: const SizedBox(
            width: 100,
            height: 50,
            child: Center(
              child: Text("Logout"),
            ),
          ),
        ),
      ],
    );
  }
}
