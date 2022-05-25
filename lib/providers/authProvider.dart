import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier{
  String? accessToken;
  String username = "";
  String userId = "";
  List<dynamic> eventsParticipated = [];
  String? error;

  Future<void> login(String email, String password) async {

    var response = await http.post(Uri.parse("https://e-sports-game.herokuapp.com/auth/login"), body: {
      "email" : email,
      "password" : password,
    });

    Map<String,dynamic> data = jsonDecode(response.body);

    if(response.statusCode == 200){
      accessToken = data["accessToken"];
      username = data["username"];
      userId = data["userId"];
      eventsParticipated = data["eventsParticipated"];
      error = null;
    }
    else {
      error = data["error"];
      accessToken = null;
    }

    notifyListeners();
  }

}