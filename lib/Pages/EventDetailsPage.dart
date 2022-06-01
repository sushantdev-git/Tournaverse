import 'dart:convert';

import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:e_game/konstants/constants.dart';
import 'package:e_game/providers/authProvider.dart';
import 'package:e_game/widgets/EventDetail.dart';
import 'package:e_game/widgets/GameRules.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/eventProvider.dart';
import 'package:e_game/modals/Event.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';


class EventsDetailsPage extends StatefulWidget {
  final String eventId;
  final GameType gType;
  const EventsDetailsPage({required this.eventId, required this.gType, Key? key}) : super(key: key);

  @override
  State<EventsDetailsPage> createState() => _EventsDetailsPageState();
}

class _EventsDetailsPageState extends State<EventsDetailsPage> {

  late Razorpay razorpay;

  @override
  void initState(){
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlePaymentExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response)  async {

    await Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: "SUCCESS: We are verifying payment on our side!!", timeInSecForIosWeb: 4,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );

    await Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: "Once it's completed this event will be available in My Event section of profile.", timeInSecForIosWeb: 4,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }
  void handlePaymentError(PaymentFailureResponse response) async {
    Fluttertoast.showToast(
        msg: "Payment failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  void handlePaymentExternalWallet(){
    print("This is coming from razorpay success");
  }

  Future<void> openCheckout(context, String gameId) async {

    print("open checkout called");
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    var order = await auth.post(endPoint: "eventRegister/createOrder", body: {
      "userId": auth.userId,
      "eventId" : widget.eventId,
    });

    Event event = Provider.of<EventProvider>(context, listen: false).getEventById(widget.eventId, widget.gType);

    var data = jsonDecode(order.body);

    data["notes"]["gameId"] = gameId;

    var options = {
      "key":"rzp_test_HlZrWo63cVl1iO",
      "amount": data["amount"],
      "name":"Tourney",
      "description": "paying for event ${event.eventName} , ${event.eventId}",
      "order_id": data["id"],
      "currency" : data["currency"],
      "prefill":{
        "contact":"1234567891",
        "email":"random@gmail.com",
      },
      "notes": data["notes"],
    };

    try{
        razorpay.open(options);
    }
    catch(err){
      print(err.toString());
    }
  }

  @override
  dispose(){
    super.dispose();
    razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    Event event = Provider.of<EventProvider>(context).getEventById(widget.eventId, widget.gType);
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
                    background: Hero(
                      tag: event.eventId,
                      child: Image.network(event.imageUrl,
                          fit: BoxFit.cover,
                          color: Colors.white.withOpacity(0.3),
                          colorBlendMode: BlendMode.modulate),
                    ),
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
                            itemExtent: name == "Details" ? 500 : name == "Rules" ? 1600 : 1600,
                            delegate: SliverChildListDelegate(
                              [
                                if(name == "Details") EventDetail(eventId: widget.eventId,gType: widget.gType, onTap: openCheckout),
                                if(name == "Rules") const GameRules(),
                                if(name == "Updates") const GameRules()
                              ]
                            ),
                          )
                        )
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
