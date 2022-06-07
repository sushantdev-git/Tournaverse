import 'package:flutter/material.dart';

class QueryCard extends StatelessWidget {
  const QueryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 70,
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xff5300CB),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          splashColor: Colors.black26,
          highlightColor: Colors.black12,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Query Title",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Created by - Sushant",
                  style: TextStyle(fontSize: 12, color: Colors.white60),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
