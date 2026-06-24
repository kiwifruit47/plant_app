import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImagePreprocessor {
  Future<Float32List> preprocessImageMobileNetV2(Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) throw Exception("Could not decode image");

    //resizing bc MobileNetV2 expects 224x224 input
    img.Image resized = img.copyResize(image, width: 224, height: 224);

    // buffer
    final input = Float32List(1 * 224 * 224 * 3);
    int index = 0;

    // fill buffer with normalized pixel values
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);

        final r = (pixel.r / 127.5) - 1.0;
        final g = (pixel.g / 127.5) - 1.0;
        final b = (pixel.b / 127.5) - 1.0;

        input[index++] = r;
        input[index++] = g;
        input[index++] = b;
      }
    }

    return input;
  }
}
