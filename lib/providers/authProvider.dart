import 'dart:convert';
import 'package:e_game/konstants/constants.dart';
import 'package:e_game/modals/Event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../modals/Payment.dart';
import '../modals/User.dart';

class AuthProvider extends ChangeNotifier {
  //the auth provider class is managing all the api class and app authorized state

  late User currentUser;

  String? error;
  String? success;
  bool fetchingApi = true;

  String baseUrl = "https://e-sports-game.herokuapp.com/";
  final _storage = const FlutterSecureStorage();
  String? accessToken;

  Future<void> login({required String email, required String password}) async {
    fetchingApi = true;
    notifyListeners();

    var response = await post(
      endPoint: "auth/login",
      body: {
        "email": email,
        "password": password,
      },
      retry: false,
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await _storage.write(key: "refreshToken", value: data["refreshToken"]);

      currentUser = User(
        name: data["username"],
        userId: data["userId"],
        email: data["email"],
        phoneNo: data["phoneNo"],
        eventsParticipated: cnvResToEvent(data["eventsParticipated"]),
        usertype: getUserType(data["userType"]),
        myPayments: [],
      );

      error = null;
      accessToken = data["accessToken"];
    } else {
      error = data["error"];
    }

    fetchingApi = false;
    notifyListeners();
  }

  List<Event> cnvResToEvent(var data) {
    List<Event> eList = [];

    for (var x in data) {
      var event = x["event"];
      Event newEvent = Event(
        eventId: event["_id"],
        entryFee: event["entryFee"],
        eventName: event["eventName"],
        eventTime: DateTime.parse(event["eventTime"]),
        gameName: event["gameName"],
        gameMap: event["gameMap"],
        gameMode: event["gameMode"],
        imageUrl: event["backgroundImage"],
        totalSlots: event["totalSlots"],
        userRegistered: event["userRegistered"],
        creatorId: event["creator"]["userId"],
        creatorName: event["creator"]["username"],
      );
      eList.add(newEvent);
    }

    eList.sort((a, b) => a.eventTime.compareTo(b.eventTime));
    return eList;
  }

  Future<void> register({
    required String email,
    required String password,
    required String phoneNo,
    required String username,
  }) async {
    fetchingApi = true;
    notifyListeners();

    http.Response res = await post(
        endPoint: "auth/register",
        body: {
          "email": email,
          "password": password,
          "username": username,
          "phoneNo": phoneNo,
        },
        retry: false,
    );

    Map<String, dynamic> data = jsonDecode(res.body);

    if (res.statusCode == 201) {
      success = data["success"];
    } else {
      error = data["error"];
    }

    fetchingApi = false;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    if (await _storage.containsKey(key: "refreshToken") == false) {
      fetchingApi = false;
      notifyListeners();
      return;
    }

    http.Response response = await http.get(
      Uri.parse("${baseUrl}auth/autoLogin"),
      headers: {
        "Authorization": "Bearer ${await _storage.read(key: "refreshToken")}"
      },
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      currentUser = User(
        name: data["username"],
        userId: data["userId"],
        email: data["email"],
        phoneNo: data["phoneNo"],
        eventsParticipated: cnvResToEvent(data["eventsParticipated"]),
        usertype: getUserType(data["userType"]),
        myPayments: [],
      );
      error = null;
      accessToken = data["accessToken"];
    } else if (response.statusCode == 403 || response.statusCode == 404) {
      autoLogout();
    } else {
      error = data["error"];
    }

    fetchingApi = false;
    notifyListeners();
  }

  Future<void> fetchMyPayments() async {
    fetchingApi = true;
    notifyListeners();

    var response = await post(endPoint: 'payment/myPayments', body: {
      "userId": currentUser.userId,
    });

    print(response.statusCode);
    List<dynamic> data = jsonDecode(response.body);
    print(data);

    if (response.statusCode == 200) {
      List<Payment> pList = [];

      for (var ele in data) {
        Payment p = Payment(
          id: ele["_id"],
          createdAt: DateTime.parse(ele["created_at"]),
          status: ele["status"],
          amount: ele["amount"],
          eventName: ele["event"]["eventName"],
        );
        pList.add(p);
      }

      currentUser.myPayments = pList;
    }
    fetchingApi = false;
    notifyListeners();
  }

  Future<http.Response> get({
    required String endPoint,
    bool retry = false,
  }) async {
    var response = await http.get(
      Uri.parse(baseUrl + endPoint),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 403) {
      //if user is un authorized we have to refresh the access token
      http.Response res = await fetchAccessToken();
      if (res.statusCode == 200 && retry == false) {
        return await get(endPoint: endPoint, retry: true);
      } else {
        error = jsonDecode(res.body)["error"];
      }
    }

    return response;
  }

  Future<http.Response> post({
    required String endPoint,
    required Map<String, dynamic> body,
    bool retry = false,
  }) async {
    var response = await http.post(
      Uri.parse(baseUrl + endPoint),
      headers: {"Authorization": "Bearer $accessToken"},
      body: body,
    );

    if (response.statusCode == 403) {
      //if user is un authorized we have to refresh the access token
      http.Response res = await fetchAccessToken();
      if (res.statusCode == 200 && retry == false) {
        return await post(endPoint: endPoint, body: body, retry: true);
      } else {
        error = jsonDecode(res.body)["error"];
      }
    }

    return response;
  }

  Future<http.Response> fetchAccessToken() async {
    if (await _storage.containsKey(key: "refreshToken") == false) {
      return http.Response("", 403);
    }

    http.Response response = await http.get(
      Uri.parse("${baseUrl}auth/refresh"),
      headers: {
        "Authorization": "Bearer ${await _storage.read(key: "refreshToken")}"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      accessToken = data["accessToken"];
    }
    if (response.statusCode == 403) {
      autoLogout();
    }
    return response;
  }

  void autoLogout() {
    accessToken = null;
    _storage.deleteAll();
    notifyListeners();
  }
}
