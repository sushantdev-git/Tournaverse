import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 200,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xff0e1f3a),
        image: const DecorationImage(
          image: NetworkImage(
              "https://www.theindianwire.com/wp-content/uploads/2020/06/screen-post-hIXmJH9xhoo-unsplash-1024x673.jpg",
          ),
          fit: BoxFit.cover,
          opacity: 0.3,
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("First Event", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          Text("#37sdjf384d", style: TextStyle(color: Colors.white, fontSize: 17,),),
          SizedBox(height: 10,),
          Text("10th May 2022", style: TextStyle(color: Colors.white, fontSize: 17,),),
          SizedBox(height: 10,),
          Text("Registered User - 10/50", style: TextStyle(color: Colors.white, fontSize: 17,),),
          SizedBox(height: 10,),
          Text("Entry Fee - Rs50", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
