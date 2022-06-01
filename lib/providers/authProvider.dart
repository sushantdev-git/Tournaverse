import 'dart:convert';
import 'package:e_game/konstants/constants.dart';
import 'package:e_game/modals/Event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {

  //the auth provider class is managing all the api class and app authorized state

  String username = "";
  String userId = "";
  List<Event> eventsParticipated = [];
  String? error;
  String? success;
  bool fetchingApi = true;
  UserType type = UserType.user;

  String baseUrl = "https://e-sports-game.herokuapp.com/";
  final _storage = const FlutterSecureStorage();
  String? accessToken;


  Future<void> login({required String email, required String password}) async {
    fetchingApi = true;
    notifyListeners();

    var response = await post(endPoint:"auth/login", body: {
      "email": email,
      "password": password,
    }, retry: false);


    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await _storage.write(key: "refreshToken", value: data["refreshToken"]);
      username = data["username"];
      userId = data["userId"];
      eventsParticipated = cnvResToEvent(data["eventsParticipated"]);
      error = null;
      accessToken= data["accessToken"];
      type = getUserType(data["userType"]);

    } else {
      error = data["error"];
    }

    fetchingApi = false;
    notifyListeners();
  }

  List<Event> cnvResToEvent(var data){
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
    return eList;
  }

  Event getEventById(String? id) {
    //finding event with given id
    List<Event> eventList = eventsParticipated;
    for (Event e in eventList) {
      if (e.eventId == id) return e;
    }
    return Event(
        eventId: "randomString1233",
        entryFee: 50,
        eventName: "Not found event",
        eventTime: DateTime.now(),
        gameName: "Battleground",
        gameMap: "Erangle",
        gameMode: "FPP",
        imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTD-_y_GWqOa1xLPPUJKSjQCQ1RZe6KXhsP9g&usqp=CAU",
        totalSlots: 20,
        userRegistered: [1, 2, 3],
        creatorId: "random",
        creatorName: "random"
    );
  }

  Future<void> register ( {required String email, required String password, required String phoneNo, required String username}) async {
    fetchingApi = true;
    notifyListeners();


    http.Response res = await post(endPoint: "auth/register", body: {
      "email":email,
      "password":password,
      "username":username,
      "phoneNo":phoneNo,
    }, retry: false);

    Map<String,dynamic> data = jsonDecode(res.body);

    if(res.statusCode == 201){
      success = data["success"];
    }
    else{
      error = data["error"];
    }

    fetchingApi = false;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    if(await _storage.containsKey(key: "refreshToken") == false) {
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

    if(response.statusCode == 200){
      await _storage.write(key: "refreshToken", value: data["refreshToken"]);
      username = data["username"];
      userId = data["userId"];
      eventsParticipated = cnvResToEvent(data["eventsParticipated"]);
      error = null;
      accessToken = data["accessToken"];
      type = getUserType(data["userType"]);
    }
    else{
      error = data["error"];
    }

    fetchingApi = false;
    notifyListeners();
  }


  Future<http.Response> get({required String endPoint, bool retry = false}) async {
    var response = await http.get(
      Uri.parse(baseUrl + endPoint),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 403) {
      //if user is un authorized we have to refresh the access token
      http.Response res = await fetchAccessToken();
      if (res.statusCode == 200 && retry == false) {
        return await get(endPoint : endPoint,  retry: true);
      } else {
        error = jsonDecode(res.body)["error"];
      }
    }

    return response;
  }

  Future<http.Response> post({required String endPoint, required Map<String, dynamic> body,  bool retry = false }) async {

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
    if(response.statusCode == 403) {
      autoLogout();
    }
    return response;
  }

  void autoLogout(){
    accessToken = null;
    _storage.deleteAll();
    notifyListeners();
  }
}
