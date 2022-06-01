import 'package:e_game/Pages/EventsPage.dart';
import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:e_game/konstants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          auth.username,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Consumer<AuthProvider>(builder: (context, _auth, _) {
          return _auth.fetchingApi
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    _auth.tryAutoLogin();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EventsPage(
                          imageUrl: "assets/images/cod.jpg",
                          name: "My Events",
                          gType: GameType.myEvent,
                        ),
                      ),
                    );
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text("My Events"),
                    ),
                  ),
                );
        }),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () => {auth.autoLogout()},
          child: const SizedBox(
            width: double.infinity,
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
