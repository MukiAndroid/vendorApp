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
import 'package:flutter_auth/services/position.dart';
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

  var isConfigureAWS = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    _configureAmplify();
    
    determinePosition().then((value) => {

      print("Location : $value")

    });


    
    

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

              loading
                  ? Center(
                child: CircularProgressIndicator.adaptive(),
              ) :  RoundedButton(
                text: "LOGIN",
                press: () {
                  if (loginformkey.currentState.validate()) {
                    login();
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              // AlreadyHaveAnAccountCheck(
              //   press: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return SignUpScreen();
              //         },
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {

    setState(() {
      loading = true;
    });

    print("emailData : $emailData");
    print("password : $passData");

    if (isConfigureAWS == true) {
      try {
        await Amplify.Auth.signIn(username: emailData, password: passData);

        setState(() {
          loading = false;
        });
        print("User Login success");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("User Login successfully"),
        ));

        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => DetailScreen(),
          ),
        );

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => DetailScreen()));
      } on AuthException catch (e) {

        if (e.message.contains('There is already a user signed in')) {
            await Amplify.Auth.signOut();
            login();

            setState(() {
              loading = false;
            });
            return;
        }else if (e.message.contains('User not found in the system')) {
          try {


            await Amplify.Auth.signUp(username: emailData, password: passData);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("$emailData is successfully sign up"),
            ));

            setState(() {
              loading = false;
            });

            return;
          } on AuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.message),
            ));

            setState(() {
              loading = false;
            });

            return;
          }
        }else if (e.message.contains('Failed since user is not authorized')) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Enter valid id password"),
          ));

          setState(() {
            loading = false;
          });

          return;

        }else{

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message),
          ));

          setState(() {
            loading = false;
          });

          return;
        }

    //

        // print('An error occurred login: $e');
        // print(e.toString());
        print(e.message);
        print("*******");

        // User not confirmed in the system.

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
        ));

      }
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("AWS is not Configure"),
      ));
    }

    // Future<String> _onSignup(LoginData data) async {
    //   try {
    //     await Amplify.Auth.signUp(
    //       username: data.name,
    //       password: data.password,
    //       options: CognitoSignUpOptions(userAttributes: {
    //         'email': data.name,
    //       }),
    //     );
    //
    //     _data = data;
    //   } on AuthException catch (e) {
    //     return '${e.message} - ${e.recoverySuggestion}';
    //   }
    // }
  }

  Future<void> _configureAmplify() async {
    try {
      if (Amplify.isConfigured == false) {
        await Amplify.addPlugin(AmplifyAuthCognito());
        await Amplify.configure(amplifyconfig);
        isConfigureAWS = true;
        setState(() {});
      }
    } on Exception catch (e) {
      print('An error occurred configuring Amplify: $e');
    }
  }



// void userExist(email String) {
// return this.cognitoService.userExist(email.toLowerCase()).then(res => {
// return false;
// }).catch(error => {
// const code = error.code;
// console.log(error);
// switch (code) {
// case 'UserNotFoundException':
// return !this.redirectToRegister(email);
// case 'NotAuthorizedException':
// return true;
// case 'PasswordResetRequiredException':
// return !this.forgotPassword(email);
// case 'UserNotConfirmedException':
// return !this.redirectToCompleteRegister(email);
// default:
// return false;
// }
// });
// }
}
