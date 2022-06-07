import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:e_game/widgets/QueryCard.dart';
import 'package:flutter/material.dart';

class QueriesPage extends StatelessWidget {
  const QueriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xff171D2F),
                  content: SizedBox(
                    height: 250,
                    width: 350,
                    child: Column(
                      children: [
                        const Text("Create New Query",
                            style: whiteTextThemeHeader),
                        const SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          decoration: getInputDecoration(
                            "Enter a title",
                          ),
                          style: whiteTextTheme,
                          cursorColor: Colors.white,
                          onChanged: (val) {},
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Center(
                              child: Text("Create"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            backgroundColor: primaryColor,
            child: const Icon(
              Icons.add,
              color: Colors.black87,
            ),
          ),
          appBar: AppBar(
            title: const Text("Queries"),
            backgroundColor: const Color(0xff0b121f),
            bottom: const TabBar(tabs: [
              Tab(text: "Ongoing"),
              Tab(
                text: "Resolved",
              ),
            ]),
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, ind) => const QueryCard(),
                  itemCount: 10,
              ),
              const Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}
