import 'package:e_game/Pages/HomePage.dart';
import 'package:e_game/Pages/LoginPage.dart';
import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:e_game/providers/eventProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import './Pages/HomePage.dart';


void main() async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EventProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.purpleAccent,
          scaffoldBackgroundColor: scaffoldColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
            )
          )
        ),
        home: const LoginPage(),
      ),
    );
  }
}
