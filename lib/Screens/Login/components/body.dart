import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/detail_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

import '../../../amplifyconfiguration.dart';



class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();


}

class _BodyState extends State<Body> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final loginformkey = GlobalKey<FormState>();

  var emailData = '';
  var passData = '';


  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: loginformkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputForm(
                controller: email,
                hintText: "Your Email",
                onChanged: (value) {
                  emailData = value;
                },
                callback: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please Enter Your Email Id';
                  }
                  if (!EmailValidator.validate(val)) {
                    return 'Please Enter valid Email Id';
                  }
                  return null;
                },
              ),
              RoundedPasswordField(

                validate: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please Enter Your password';
                  }
                  if (val.length < 8) {
                    return 'Password length must be 8 characters';
                  }
                  return null;
                },
                onChanged: (value) {
                  passData = value;
                },
              ),
              RoundedButton(
                text: "LOGIN",
                press: () {
                  if (loginformkey.currentState.validate()) {
                    login();
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {

    try {
      await Amplify.Auth.signIn(username: emailData, password: passData);

      print("User Login success");

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailScreen()));

    } on Exception catch (e) {
      print('An error occurred login: $e');
      print(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }




  }

  Future<void> _configureAmplify() async {
    try {
      if (Amplify.isConfigured == false){
        await Amplify.addPlugin(AmplifyAuthCognito());
        await Amplify.configure(amplifyconfig);
      }
    } on Exception catch (e) {
      print('An error occurred configuring Amplify: $e');


    }
  }

}
