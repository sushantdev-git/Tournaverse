import 'package:e_game/Pages/HomePage.dart';
import 'package:e_game/Pages/LoginPage.dart';
import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:e_game/providers/authProvider.dart';
import 'package:e_game/providers/eventProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import './Pages/HomePage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, EventProvider>(
          update: (ctx, auth, _) => EventProvider(auth),
          create: (BuildContext context) =>
              EventProvider(Provider.of<AuthProvider>(context, listen: false)),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Joyes',
        theme: ThemeData(
          primaryColor: primaryColor,
          accentColor: Colors.white,
          scaffoldBackgroundColor: scaffoldColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              onSurface: Colors.grey,
            ),
          ),
          timePickerTheme: const TimePickerThemeData(
            backgroundColor: Color(0xff121212),
            dialHandColor: primaryColor,
            dialTextColor: Colors.white,
            hourMinuteColor: Colors.white,
            hourMinuteTextColor: primaryColor,
            dayPeriodTextColor: Colors.white,
            entryModeIconColor: Colors.white,
            helpTextStyle: TextStyle(color: Colors.white),
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
            primary: Colors.white,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )),
          textTheme: TextTheme(
            headline1: GoogleFonts.roboto(
                fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
            headline2: GoogleFonts.roboto(
                fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
            headline3:
                GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.w400),
            headline4: GoogleFonts.roboto(
                fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            headline5:
                GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
            headline6: GoogleFonts.roboto(
                fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
            subtitle1: GoogleFonts.roboto(
                fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
            subtitle2: GoogleFonts.roboto(
                fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
            bodyText1: GoogleFonts.roboto(
                fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
            bodyText2: GoogleFonts.roboto(
                fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            button: GoogleFonts.roboto(
                fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
            caption: GoogleFonts.roboto(
                fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
            overline: GoogleFonts.roboto(
                fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
          ),
        ),
        home: const ChildSelector(),
      ),
    );
  }
}

class ChildSelector extends StatelessWidget {
  const ChildSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.accessToken == null) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    return authProvider.accessToken != null
        ? const HomePage()
        : const LoginPage();
  }
}
