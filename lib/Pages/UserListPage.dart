import 'package:e_game/konstants/constants.dart';
import 'package:e_game/widgets/UserListCard.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  final List<dynamic> userRegistered;
  final GameType gType;
  const UserListPage(
      {required this.userRegistered, required this.gType, Key? key})
      : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late List<dynamic> displayList;
  @override
  initState() {
    displayList = widget.userRegistered;
    super.initState();
  }

  void filterList(String val){
    val = val.trim();

    List<dynamic> tempList = widget.userRegistered.where((element) => element["userGameId"].toLowerCase().startsWith(val.toLowerCase())).toList();

    setState((){
      displayList = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User List"),
          backgroundColor: const Color(0xff0b121f),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                onChanged: filterList,
                decoration: InputDecoration(
                  hintText: "Enter User Game Id",
                  suffixIcon: const Icon(Icons.search, color: Colors.white,),
                  fillColor: const Color(0xff111928),
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.white60),
                  contentPadding: const EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(width: 0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(width: 0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white70,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, ind) {
                    return UserListCard(
                      username: displayList[ind]["user"]["username"],
                      userGameId: displayList[ind]["userGameId"],
                      gType: widget.gType,
                    );
                  },
                  itemCount: displayList.length,
                ),
              )
            ],
          ),
        ));
  }
}
