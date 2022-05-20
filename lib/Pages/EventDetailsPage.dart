import 'package:flutter/material.dart';

import '../widgets/EventsCard.dart';

class EventsDetailsPage extends StatelessWidget {
  const EventsDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xff0e182b),
            expandedHeight: 170,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Events Details Page",
                style: TextStyle(fontSize: 15),
              ),
              background: Hero(
                tag: "FirstEvent",
                child: Image.network(
                    "https://www.theindianwire.com/wp-content/uploads/2020/06/screen-post-hIXmJH9xhoo-unsplash-1024x673.jpg",
                    fit: BoxFit.cover,
                    color: Colors.white.withOpacity(0.6),
                    colorBlendMode: BlendMode.modulate),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //your widgets
                    Row(
                      children: const [
                        Icon(
                          Icons.timelapse,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "10th May 2022",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: const [
                        Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "09:30 PM",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: const [
                        Icon(
                          Icons.attach_money_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Entry Fee - Rs50",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: const [
                        Icon(
                          Icons.money_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Winning Prize - Rs 3000",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
