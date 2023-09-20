import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

void main(List<String> args) async {
  final imageInputFileName = args[0];
  print(imageInputFileName);
  final imageAmount = args[1];
  print(imageAmount);
  final outputFolder = args[2];
  print(outputFolder);

  final images = <img.Image>[];

  for (var i = 0; i < int.parse(imageAmount); i++) {
    final loadImages = await loadImage(filename: imageInputFileName);
    images.add(loadImages);
  }

  final mergedImage = img.Image(
    width: 540,
    height: images.map((e) => e.height).reduce((a, b) => (a + b)),
  );

  for (var pixel in mergedImage) {
    for (var y in images) {
      var imageY = y.height;

      pixel
        ..r = pixel.x
        ..g += imageY;
    }
  }

  saveImage(
    filename: path.normalize('$outputFolder/background'),
    image: mergedImage,
  );
}

Future<img.Image> loadImage({
  required String filename,
}) async {
  final file = File(
    path.join(
      Directory.current.path,
      filename,
    ),
  );
  final imageBytes = await file.readAsBytes();
  final img.Image image = img.decodePng(imageBytes)!;
  return image;
}

Future<void> saveImage({
  required String filename,
  required img.Image image,
}) async {
  final file = File(
    path.join(
      Directory.current.path,
      filename,
    ),
  );
  final imageBytes = img.encodePng(image);
  await file.writeAsBytes(imageBytes);
}
