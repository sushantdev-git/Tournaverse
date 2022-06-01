import 'package:e_game/konstants/ThemeConstants.dart';
import 'package:e_game/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool login = true;
  final String loginText = "Let's\nLog you in. 🌠 ";
  final String registerText = "Go ahead,\nCreate an account. 🚀 ";
  String displayText = "Let's\nLog you in. 🌠 ";

  String name = "";
  String email = "";
  String phoneNo = "";
  String password = "";
  bool changingText = false;
  bool isInit = true;

  final _form = GlobalKey<FormState>();

  changeText() async {

    changingText = true;
    var dpT = login ? loginText.runes : registerText.runes;
    String dpTF = String.fromCharCodes(dpT, 0, dpT.length-1);
    int sz = dpTF.length;
    int ind = 0;
    String text;

    while (ind <= sz) {
      text = dpTF.substring(0, ind);
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        displayText = text;
      });
      ind++;
    }

    changingText = false;
  }

  //validators
  String? phoneNoValidator(String? no) {
    if (no == null) return "Enter you Phone no";
    if (no.length < 10 || no.length > 10) return "Phone no must have length 10";
    RegExp regExp = RegExp(r"^[6-9]\d{9}$");
    if (!regExp.hasMatch(no)) return "Enter Phone no in valid format";
    return null;
  }

  String? emailValidator(String? email) {
    if (email == null) return "Enter you email";
    RegExp regExp = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
    if (!regExp.hasMatch(email)) return "Enter a valid email address";
    return null;
  }

  String? passwordValidator(String? password) {
    if (password == null) return "Enter you password";
    if (password.length < 8) return "Minimum password length is 8";
    RegExp regExp = RegExp(
        r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$");
    if (!regExp.hasMatch(password)) {
      return "Password must contain one number,\none letter and one special character";
    }
    return null;
  }

  Future<void> handleLogin(AuthProvider auth) async {
    print("handle called");
    if(login) {
      await auth.login(email: email, password: password);
    } else {
      await auth.register(email: email, password: password, phoneNo: phoneNo, username: name);
    }
  }

  //setters
  void setName (name){
    this.name = name;
  }

  void setEmail (email) {
    this.email = email;
  }

  void setPassword (password){
    this.password = password;
  }

  void setPhoneNo (phoneNo){
    this.phoneNo = phoneNo;
  }

  @override
  void didChangeDependencies() async {
    //if this page is loaded we fetch event list from firebase
    if(isInit){
      //if this is page is loaded for first time we are going to try auto login....
      AuthProvider authProvider = Provider.of<AuthProvider>(context);
      await authProvider.tryAutoLogin();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: SizedBox(
            height: mediaQuery.height-50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayText,
                  style: const TextStyle(
                    // foreground: Paint()..shader = linearGradient,
                    color: Colors.white,
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: login ? 50 : 40,
                ),
                if (login)
                  LoginForm(
                    formKey: _form,
                    emailValidator: emailValidator,
                    passwordValidator: passwordValidator,
                    setEmail: setEmail,
                    setPassword: setPassword,
                  )
                else
                  RegistrationForm(
                    formKey: _form,
                    emailValidator: emailValidator,
                    passwordValidator: passwordValidator,
                    phoneNoValidator: phoneNoValidator,
                    setEmail: setEmail,
                    setPassword: setPassword,
                    setName: setName,
                    setPhoneNo: setPhoneNo,
                  ),
                if (authProvider.fetchingApi) ...[
                  const Center(
                    child: CircularProgressIndicator(color: primaryColor,),
                  )
                ] else ...[
                  ElevatedButton(
                    onPressed: () => {
                      if (_form.currentState!.validate())
                        {
                          handleLogin(authProvider),
                        }
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(login ? "Login" : "SignUp"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (authProvider.error != null)
                    Center(
                      child: Text(
                        authProvider.error.toString(),
                        style: const TextStyle(
                            color: Colors.redAccent, fontStyle: FontStyle.italic),
                      ),
                    ),
                  if (authProvider.success != null)
                    Center(
                      child: Text(
                        authProvider.success.toString(),
                        style: const TextStyle(
                            color: Colors.greenAccent, fontStyle: FontStyle.italic),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: TextButton(
                        onPressed: () => {
                          if(!changingText){
                            //if we are changing type of event we should also remove error or success
                            authProvider.success = null,
                            authProvider.error = null,
                            setState(() {
                              login = !login;
                            }),
                            changeText()
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              login
                                  ? "Don't have an account ? "
                                  : "Have an account ? ",
                              style: const TextStyle(color: Colors.white60),
                            ),
                            Text(
                              login ? "SignUp" : "Login",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationForm extends StatelessWidget {
  final formKey;
  final emailValidator;
  final passwordValidator;
  final phoneNoValidator;
  final setName;
  final setEmail;
  final setPassword;
  final setPhoneNo;
  const RegistrationForm({
    required this.formKey,
    required this.emailValidator,
    required this.passwordValidator,
    required this.phoneNoValidator,
    required this.setEmail,
    required this.setName,
    required this.setPassword,
    required this.setPhoneNo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        key: new Key('1'),
        children: [
          TextFormField(
            style: whiteTextTheme,
            cursorColor: Colors.white,
            decoration: getInputDecoration("Enter you email"),
            keyboardType: TextInputType.emailAddress,
            validator: emailValidator,
            onChanged: setEmail,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            style: whiteTextTheme,
            cursorColor: Colors.white,
            decoration: getInputDecoration("Enter you password"),
            validator: passwordValidator,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            onChanged: setPassword,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            style: whiteTextTheme,
            cursorColor: Colors.white,
            decoration: getInputDecoration("Enter you name"),
            validator: (name) {
              if (name == null) return "Enter you name";
              name = name.trim();
              if (name.length < 4) return "Enter a valid name";
              return null;
            },
            onChanged: setName,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            style: whiteTextTheme,
            cursorColor: Colors.white,
            decoration: getInputDecoration("Enter you mobile no"),
            validator: phoneNoValidator,
            keyboardType: TextInputType.phone,
            onChanged: setPhoneNo,
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final formKey;
  final emailValidator;
  final passwordValidator;
  final setPassword;
  final setEmail;
  const LoginForm({
    required this.formKey,
    required this.emailValidator,
    required this.passwordValidator,
    required this.setEmail,
    required this.setPassword,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        key: new Key('2'),
        children: [
          TextFormField(
            style: whiteTextTheme,
            cursorColor: Colors.white,
            decoration: getInputDecoration("Enter you email"),
            keyboardType: TextInputType.emailAddress,
            validator: emailValidator,
            onChanged: setEmail,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            style: whiteTextTheme,
            cursorColor: Colors.white,
            decoration: getInputDecoration("Enter you password"),
            validator: passwordValidator,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            onChanged: setPassword,
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
