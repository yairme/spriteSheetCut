import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:texture_packer/texture_packer.dart';
import 'package:image/image.dart' as img;

void main(List<String> args) async {
  final imageInputFileName = args[0];
  print(imageInputFileName);
  final jsonInputFileName = args[1];
  print(jsonInputFileName);
  final outputFileName = args[2];
  print(outputFileName);

  final image = await loadImage(
    filename: imageInputFileName,
  );
  final json = await loadJson(
    filename: jsonInputFileName,
  );

  //Do something with image here by looking at the json

  int slices = 1;
  for (int i = 0; i < slices; i++) {
    saveImageSlice(
      filename: outputFileName,
      imageSlice: image,
    );
  }
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

Future<Map<String, dynamic>> loadJson({
  required String filename,
}) async {
  final file = File(
    path.join(
      Directory.current.path,
      filename,
    ),
  );
  final jsonString = await file.readAsString();
  return json.decode(jsonString);
}

Future<void> saveImageSlice({
  required String filename,
  required img.Image imageSlice,
}) async {
  final file = File(
    path.join(
      Directory.current.path,
      filename,
    ),
  );
  final imageBytes = img.encodePng(imageSlice);
  await file.writeAsBytes(imageBytes);
}
