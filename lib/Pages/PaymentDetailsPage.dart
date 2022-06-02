import 'package:e_game/providers/authProvider.dart';
import 'package:e_game/widgets/PaymentDisplayCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../konstants/ThemeConstants.dart';

class PaymentDetailsPage extends StatelessWidget {

  const PaymentDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xff0e182b),
            expandedHeight: 170,
            title: const Text(
              "My Payments",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: "My Payments",
                child: Image.asset("assets/images/wallet.jpeg",
                    fit: BoxFit.cover,
                    color: Colors.white.withOpacity(0.5),
                    colorBlendMode: BlendMode.modulate),
              ),
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 35),
            sliver: auth.fetchingApi
                ? const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, ind) {
                        return PaymentDisplayCard(
                          payment: auth.currentUser.myPayments[ind],
                        );
                      },
                      childCount: auth.currentUser.myPayments.length,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
