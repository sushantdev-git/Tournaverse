import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool login = true;

  @override
  Widget build(BuildContext context) {
    Size _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        child: Container(
          height: _mediaQuery.height ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                login ? "Let's\nLog you in. 💜" : "Let's\nCreate an account. 💜",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              if (!login) ...[
                TextField(
                  style: whiteTextTheme,
                  cursorColor: Colors.white,
                  decoration: getInputDecoration("Enter you name"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  style: whiteTextTheme,
                  cursorColor: Colors.white,
                  decoration: getInputDecoration("Enter you mobile no"),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
              TextField(
                style: whiteTextTheme,
                cursorColor: Colors.white,
                decoration: getInputDecoration("Enter you email"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                style: whiteTextTheme,
                cursorColor: Colors.white,
                decoration: getInputDecoration("Enter you password"),
              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                onPressed: () => {},
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text( login ? "Login" : "Register" ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: TextButton(
                    onPressed: () => {
                      setState(() {
                        login = !login;
                      })
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          login ? "Don't have an account ? " : "Have an account ? ",
                          style: const TextStyle(color: Colors.white60),
                        ),
                        Text(
                          login ? "Register" : "Login",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
