import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/thank.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/services/pickimage.dart';
import 'package:flutter_auth/services/qrscanner.dart';

import 'Login/components/background.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<String> dropdownItems = [
    'Groceries',
    "Petrol" 'pump',
    'Pharmacy',
    'Hospital',
    'Lab'
  ];
  String type = 'Hospital';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Background(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "DETAILS",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                icon: Icons.store,
                hintText: "Shop Name",
                onChanged: (value) {},
              ),
              TextFieldContainer(
                child: ListTile(
                  dense: true,
                  leading: Text('Category'),
                  trailing: DropdownButton2<String>(
                    value: type,
                    isDense: true,
                    dropdownMaxHeight: 300,
                    offset: Offset(0, -5),
                    style: const TextStyle(color: Color(0xff333333)),
                    underline: Container(color: Colors.transparent),
                    onChanged: (val) {
                      setState(() {
                        type = val;
                      });
                    },
                    items: dropdownItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              RoundedInputForm(
                textInputType: TextInputType.phone,
                icon: Icons.phone,
                hintText: "Phone Number",
                onChanged: (value) {},
              ),
              RoundedInputField(
                hintText: "GST Number",
                onChanged: (value) {},
              ),
              GestureDetector(
                onTap: pickImage,
                child: TextFieldContainer(
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: Icon(Icons.image),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => QRScanner())),
                child: TextFieldContainer(
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: Icon(Icons.qr_code_scanner),
                    ),
                  ),
                ),
              ),
              RoundedButton(
                text: "Submit",
                press: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Thank())),
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    ));
  }
}
