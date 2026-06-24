import 'dart:convert';
import 'package:flutter/services.dart';

import '../model/disease_info.dart';

class DiseaseRepository {
  Map<String, dynamic>? _cache;

  Future<void> load() async {
    final jsonString = await rootBundle.loadString('assets/description.json');
    _cache = jsonDecode(jsonString);
  }

  DiseaseInfo getInfo(String label) {
    if (_cache == null) {
      throw Exception("Disease info not loaded.");
    }

    var result = _cache![label];
    if (result != null) {
      return DiseaseInfo(
        plantName: result['plant_name'],
        diseaseName: result['disease_name'],
        description: result['description'],
        treatments: List<String>.from(result['treatments']),
      );
    } else {
      throw Exception("Label not found: $label");
    }
  }
}
