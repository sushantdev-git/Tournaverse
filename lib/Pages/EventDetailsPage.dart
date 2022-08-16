import 'dart:convert';

import 'package:e_game/Pages/PaymentDetailsPage.dart';
import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:e_game/konstants/constants.dart';
import 'package:e_game/providers/authProvider.dart';
import 'package:e_game/widgets/EventDetail.dart';
import 'package:e_game/widgets/GameRules.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../pageRouterBuilder/CustomPageRouteBuilder.dart';
import '../providers/eventProvider.dart';
import 'package:e_game/modals/Event.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventsDetailsPage extends StatefulWidget {
  final String eventId;
  final GameType gType;
  const EventsDetailsPage(
      {required this.eventId, required this.gType, Key? key})
      : super(key: key);

  @override
  State<EventsDetailsPage> createState() => _EventsDetailsPageState();
}

class _EventsDetailsPageState extends State<EventsDetailsPage> {
  Future<void> openCheckout(context, String gameId) async {
    print("open checkout called");

    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    var order = await auth.post(
      endPoint: "eventRegister/createOrder",
      body: {
        "userId": auth.currentUser.userId,
        "eventId": widget.eventId,
        "gameId": gameId,
      },
      retry: false,
      url: "https://f554-2409-4055-187-5b7a-8d45-9e00-ff60-5fc8.in.ngrok.io/",
    );

    Event event = Provider.of<EventProvider>(context, listen: false)
        .getEventById(widget.eventId, widget.gType);

    var orderData = jsonDecode(order.body);

    print(orderData);

    var mid = "PtiTgG55971042373145";
    showToast("Transaction Started....");

    var response = AllInOneSdk.startTransaction(
      mid,
      orderData["orderId"],
      orderData["amount"].toString(),
      orderData["txnToken"],
      "https://f554-2409-4055-187-5b7a-8d45-9e00-ff60-5fc8.in.ngrok.io/paytmPayment/verifyPayment",
      true,
      true,
    );
    response.then((value) async {
      print(value);
      Navigator.of(context)
          .push(CustomPageRoute(child: const PaymentDetailsPage()));
      await showToast(
          "Hey payment is completed on your side, We are verifying payment on our side.");
      await showToast("Please check after sometime in MyPayments page");
    }).catchError((onError) async {
      print("payment not completed some error");
      if (onError is PlatformException) {
        print(onError.toString());
      } else {
        print(onError.toString());
      }
      print("showing flutter toast");
      await showToast("Payment Failed, Please try again.");
    }).then((value) => Navigator.of(context).pop());
  }

  Future<void> showToast(String msg) async {
    await Fluttertoast.showToast(
      msg: msg,
      timeInSecForIosWeb: 5,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.orange,
      fontSize: 16,
    );
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Event event = Provider.of<EventProvider>(context)
        .getEventById(widget.eventId, widget.gType);
    List<String> tabName = ["Details", "Rules", "Updates"];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: true,
                  backgroundColor: const Color(0xff0e182b),
                  expandedHeight: 170,
                  title: Text(
                    event.eventName,
                    style: const TextStyle(fontSize: 20),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(event.imageUrl,
                        fit: BoxFit.cover,
                        color: Colors.white.withOpacity(0.3),
                        colorBlendMode: BlendMode.modulate),
                  ),
                  bottom: const TabBar(
                    indicatorColor: primaryColor,
                    tabs: [
                      Tab(
                        text: "Details",
                      ),
                      Tab(
                        text: "Rules",
                      ),
                      Tab(
                        text: "Updates",
                      ),
                    ],
                  ),
                ),
              )
            ];
          },
          body: TabBarView(
            children: tabName.map((name) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>(name),
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverPadding(
                            padding: const EdgeInsets.all(20),
                            sliver: SliverFixedExtentList(
                              itemExtent: name == "Details"
                                  ? 600
                                  : name == "Rules"
                                      ? 1600
                                      : 1600,
                              delegate: SliverChildListDelegate([
                                if (name == "Details")
                                  EventDetail(
                                      eventId: widget.eventId,
                                      gType: widget.gType,
                                      onTap: openCheckout),
                                if (name == "Rules") const GameRules(),
                                if (name == "Updates") const GameRules()
                              ]),
                            ))
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
