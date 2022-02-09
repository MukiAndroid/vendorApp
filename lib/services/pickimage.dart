import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future pickImage() async {
  final ImagePicker _picker = ImagePicker();
  var picked = await _picker.pickImage(source: ImageSource.camera);

  if (picked != null) {
    return picked.path;
  }
}
