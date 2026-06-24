import 'dart:convert';
import 'package:flutter/services.dart';

class LabelLoader {
  Future<List<String>> loadLabels() async {
    final jsonString = await rootBundle.loadString('assets/labels.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.cast<String>();
  }
}
