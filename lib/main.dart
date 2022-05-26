import 'package:e_game/Pages/HomePage.dart';
import 'package:e_game/Pages/LoginPage.dart';
import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:e_game/providers/authProvider.dart';
import 'package:e_game/providers/eventProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import './Pages/HomePage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider())
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
        home: const ChildSelector(),
      ),
    );
  }
}


class ChildSelector extends StatelessWidget {
  const ChildSelector({Key? key}) : super(key: key);

  Future<void> autoAuthorize(AuthProvider authProvider) async {
    if(authProvider.fetchingApi) return;
    print("auto auth 1");
    if(authProvider.accessToken != null) return;
    print("auto auth 2");
    if(await authProvider.haveRefreshToken()){
      print("auto auth 3");
      await authProvider.fetchAccessToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return FutureBuilder(
        future: autoAuthorize(authProvider),
        builder: (context, snapshot) {
          return authProvider.accessToken != null ? const HomePage() : const LoginPage();
        }
    );
  }
}
