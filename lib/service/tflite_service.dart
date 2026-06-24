import 'dart:typed_data';

import 'package:plant_app/model/disease_info.dart';
import 'package:plant_app/repository/disease_repository.dart';
import 'package:plant_app/util/image_preprocessor.dart';
import 'package:plant_app/util/label_loader.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class TFLiteService {
  static final TFLiteService _instance = TFLiteService._internal();
  factory TFLiteService() => _instance;
  TFLiteService._internal();

  final ImagePreprocessor _imagePreprocessor = ImagePreprocessor();
  final LabelLoader _labelLoader = LabelLoader();
  final DiseaseRepository _diseaseRepository = DiseaseRepository();

  tfl.Interpreter? _interpreter;
  List<String>? _labels;

  /// init model and labels
  Future<void> init() async {
    _interpreter ??= await tfl.Interpreter.fromAsset(
      'assets/plant_disease_model.tflite',
    );

    _labels ??= await _labelLoader.loadLabels();
  }

  Future<DiseaseInfo> runModel(Uint8List imageBytes) async {
    await init();

    final input = await _imagePreprocessor.preprocessImageMobileNetV2(
      imageBytes,
    );

    var output = List.filled(15, 0.0).reshape([1, 15]);

    _interpreter!.run(input.reshape([1, 224, 224, 3]), output);

    final labels = await _labelLoader.loadLabels();
    final predictedIndex = output[0].indexWhere(
      (v) => v == output[0].reduce((a, b) => a > b ? a : b),
    );
    final predictedLabel = labels[predictedIndex];

    return _diseaseRepository.getInfo(predictedLabel);
  }
}
