import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  String? accessToken;
  String username = "";
  String userId = "";
  List<dynamic> eventsParticipated = [];
  String? error;
  bool fetchingApi = false;

  static const storage = FlutterSecureStorage();

  Future<void> login(String email, String password) async {
    if(fetchingApi) return;
    fetchingApi = true;
    notifyListeners();

    var response = await http.post(
      Uri.parse("https://e-sports-game.herokuapp.com/auth/login"),
      body: {
        "email": email,
        "password": password,
      },
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {

      await storage.write(key: "refreshToken", value: data["refreshToken"]);

      accessToken = data["accessToken"];
      username = data["username"];
      userId = data["userId"];
      eventsParticipated = data["eventsParticipated"];
      error = null;

    } else {
      error = data["error"];
      accessToken = null;
    }

    fetchingApi = false;
    notifyListeners();
  }

  Future<bool> fetchAccessToken() async {
    if(fetchingApi) return false;
    fetchingApi = true;
    notifyListeners();

    print("refreshing token");
    var response = await http.get(
      Uri.parse("https://e-sports-game.herokuapp.com/auth/refresh"),
      headers: {'authorization': "Bearer ${await storage.read(key: "refreshToken")}"},
    );

    try {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {

        accessToken = data["accessToken"];
        fetchingApi = false;
        notifyListeners();
        return true;

      } else {
        accessToken = null;
        await storage.delete(key: "refreshToken");
      }
    } catch (err) {
      await storage.delete(key: "refreshToken");
    }

    fetchingApi = false;
    notifyListeners();
    return false;
  }

  Future<bool> haveRefreshToken() async {
    return await storage.containsKey(key: "refreshToken");
  }
}
