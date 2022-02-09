import 'package:flutter/material.dart';
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
      body: Column(
        children: [
          Center(
            child: Image.asset(
              'assets/images/thank.png',
              width: 100,
            ),
          ),
          RoundedButton(
            text: "Submit",
            press: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => Thank())),
          ),
        ],
      ),
    );
  }
}
