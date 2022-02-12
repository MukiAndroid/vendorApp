import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/detail_screen.dart';
import 'package:flutter_auth/components/rounded_button.dart';

class Thank extends StatefulWidget {
  const Thank({Key key}) : super(key: key);

  @override
  _ThankState createState() => _ThankState();
}

class _ThankState extends State<Thank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Center(
              child: Image.asset(
                'assets/images/thank.png',
                width: 100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RoundedButton(
              text: "Go to Form",
              press: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => DetailScreen(),
                  ),
                );
              }
            ),
          ],

        ),
      )
    );
  }
}
