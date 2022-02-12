import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/Screens/thank.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/services/pickimage.dart';
import 'package:flutter_auth/services/qrscanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'Login/components/background.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<String> dropdownItems = [
    'Groceries',
    'Petrol pump',
    'Pharmacy',
    'Hospital',
    'Lab'
  ];
  List<Items> newlist = [
    Items("5411", "Grocery Stores Supermarkets"),
    Items("5451", "Dairy Products Stores"),
    Items("5462", "Bakeries"),
    Items("5172", "Petroleum and Petroleum Products"),
    Items("5912", "Drug Stores and Pharmacies"),
    Items("8062", "Hospitals"),
    Items("8071", "Medical and Dental Laboratories"),
    Items("8011", "Doctors and Physicians"),
    Items("8021", "Dentists and Orthodontists")
  ];
  String imgpath = null;
  String name = '';
  String phone = '';
  String gst = '';
  String type = '5451';
  int val = 2;
  List<String> list = [];
  final loginformkey = GlobalKey<FormState>();

  bool loading = false;

  Position _currentPosition;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    print(type);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Background(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: loginformkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // SizedBox(height: 10),
                    Text(
                      "DETAILS",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.04),
                    RoundedInputForm(
                      callback: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please Enter Your shop name';
                        }
                        return null;
                      },
                      icon: Icons.store,
                      hintText: "Shop Name",
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    TextFieldContainer(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        // leading: Text('Category'),
                        trailing: DropdownButton2<String>(
                          value: type,
                          isDense: true,
                          // icon: Container(),
                          dropdownMaxHeight: 300,
                          offset: Offset(0, -5),
                          style: const TextStyle(color: Color(0xff333333)),
                          underline: Container(color: Colors.transparent),
                          onChanged: (val) {
                            setState(() {
                              type = val;
                            });
                          },
                          items: newlist.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value.code,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    RoundedInputForm(
                      callback: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please Enter Your shop name';
                        }
                        if (val.length > 10) {
                          return 'Please Enter valid phone number';
                        }

                        return null;
                      },
                      textInputType: TextInputType.phone,
                      icon: Icons.phone,
                      list: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.deny(RegExp(r"\s")),
                        // FilteringTextInputFormatter.deny(RegExp(".")),
                      ],
                      max: 10,
                      hintText: "Phone Number",
                      onChanged: (value) {
                        setState(() {
                          phone = value;
                        });
                      },
                    ),
                    RoundedInputForm(
                      callback: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please Enter Your shop name';
                        }

                        return null;
                      },
                      hintText: "GST Number",
                      onChanged: (value) {
                        setState(() {
                          gst = value;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        pickImage().then((value) {
                          if (value != null) {
                            setState(() {
                              imgpath = value.toString();
                            });
                          }
                        });
                      },
                      child: TextFieldContainer(
                        child: SizedBox(
                          height: imgpath != null ? 100 : 40,
                          child: Center(
                            child: imgpath != null
                                ? Image.file(File(imgpath,),height: 100,width: 100,)
                                : Icon(
                              Icons.image,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ...qrList(list),
                    list.length != 0 ?
                    Container(
                      margin: EdgeInsets.only(left: 40,right: 40),
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "QR Code : ",
                                textAlign: TextAlign.left,
                              ),
                              TextButton(onPressed: (){
                                setState(() {
                                  list = [];
                                });
                              }, child:
                              Text(
                                "Clear",
                                textAlign: TextAlign.left,
                              ),)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: <Widget>[
                              for (int i=0; i<list.length; i++)
                                Text((i+1).toString() + ". ${list[i]}")
                            ],
                          ),
                        ],

                      ),
                    ) : SizedBox(),
                    GestureDetector(
                      onTap: ()  {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => QRScanner()))
                            .then((value) {
                          if (value != null) {
                            print(value);
                            Barcode code = value;
                            setState(() {
                              list.add(code.code);
                            });
                            print("VAL DATA : " + code.code);
                          }
                        },);
                      },
                      child: TextFieldContainer(
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: Icon(Icons.qr_code_scanner),
                          ),
                        ),
                      ),
                    ),

                    loading
                        ? Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                        : RoundedButton(
                        text: "Submit",
                        press: () {

                          getUserLocation();

                          if (loginformkey.currentState.validate()) {
                            if (imgpath != null ) {
                              // && list.isNotEmpty

                              setState(() {
                                loading = true;
                              });

                              apiForLogin(name, gst, phone, type, list,imgpath,_currentPosition)
                                  .then((value) async {
                                setState(() {
                                  loading = false;
                                });
                                // print("value : " + value[].toString());
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Success'),
                                  duration: Duration(milliseconds: 500),
                                ));

                                Navigator.pushReplacement<void, void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) => Thank(),
                                  ),
                                );

                                setState(() {});
                              }).catchError((e) {
                                setState(() {
                                  loading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Please select image!')));
                            }
                          }
                        }),
                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  List<Widget> qrList(List<String> list) {
    print("VAL DATA : " + list.length.toString());
    return list.length == 0
        ? List.generate(1, (index) => Container())
        : List.generate(
      list.length,
          (index) => TextFieldContainer(
        child: SizedBox(
          height: 40,
          child: Center(
            child: Text(list.elementAt(index)),
          ),
        ),
      ),
    );
  }

  getUserLocation() async {
    _currentPosition = await locateUser();
    setState(() {
    });
  }

  Future<Position> locateUser() async {
    return await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}

Future apiForLogin(
    String shopname,
    // File file,
    String gstno,
    String num,
    String mcc,
    List qrcodes,
    filepath,
    Position _currentPosition,
    ) async {

  var uri = Uri.parse(baseApi+merchantsAPi);
  var request = new http.MultipartRequest("POST", uri);
  request.fields['name'] = shopname;
  request.fields['gst_number'] = gstno;
  request.fields['owner_primary_contact'] = num;
  request.fields['mcc'] = mcc;
  request.fields['lat'] = _currentPosition == null ? "95.2" : _currentPosition.latitude.toString();
  request.fields['lng'] = _currentPosition == null ? "93.2" : _currentPosition.longitude.toString();
  List.generate(
      qrcodes.length, (index) => request.fields["qr_codes"] = '${qrcodes[index]}');
  if (qrcodes.length == 0) {
    request.fields["qr_codes"] = "";
  }
  request.files.add(
      http.MultipartFile.fromBytes(
          'images',
          File(filepath).readAsBytesSync(),
          filename: filepath.split("/").last
      )
  );
  var response = await request.send();
  print("request url : ${request.url}");
  print("request parm : ${request.fields}");
  print(response.statusCode);
  final responseJson = await response.stream.bytesToString();
  var jsonResponse = json.decode(responseJson);
  print(jsonResponse);

  if (response.statusCode == 200) {
    if (jsonResponse["success"] == true) {
      return jsonResponse;
    } else {
      return Future.error(jsonResponse["errorMessage".toString()]);
    }
  }else{
    return Future.error(jsonResponse["errorMessage".toString()]);
  }
}

class Items {
  String name;
  String code;
  Items(this.code, this.name);
}
