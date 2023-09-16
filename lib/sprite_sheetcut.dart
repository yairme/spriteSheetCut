import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart';

Future<Image> loadImage({
  required String filename,
  required int i,
}) async {
  final file = File(
    path.join(
      Directory.current.path,
      '${filename}_${i.toString().padLeft(3, '0')}.jpg',
    ),
  );
  final bytes = await file.readAsBytes();
  final memoryImage = render.MemoryImage(bytes);
  Completer<render.ImageInfo> completer = Completer();
  memoryImage.resolve(const render.ImageConfiguration()).addListener(
    render.ImageStreamListener((render.ImageInfo info, bool _) {
      completer.complete(info);
    }),
  );
  final imageInfo = await completer.future;
  return imageInfo.image;
}

class SpritesheetCut {
    static const filename = '';
  late List<Image> images;

      final futures = [
      for (int i = 0; i < 7; i++)
        loadImage(
          filename: filename,
          i: i,
        ),
    ];
    images = await Future.wait(futures);
    
}

Future<Map<String, dynamic>> loadJson({
  required String filename,
  required int i,
}) async {
  final file = File(
    path.join(
      Directory.current.path,
      '${filename}_${i.toString().padLeft(3, '0')}.jpg',
    ),
  );
  final jsonString = await file.readAsString();
  return json.decode(jsonString);
}

import 'package:image/image.dart' as img;

void main(List<String> args) async {
  final path = args.isNotEmpty ? args[0] : 'test.png';
  final cmd = img.Command()
    // Decode the image file at the given path
    ..decodeImageFile(path) <- HERE HE LOADS THE IMAGE
    // Resize the image to a width of 64 pixels and a height that maintains the aspect ratio of the original. 
    ..copyResize(width: 64)
    // Write the image to a PNG file (determined by the suffix of the file path). 
    ..writeToFile('thumbnail.png');
  // On platforms that support Isolates, execute the image commands asynchronously on an isolate thread.
  // Otherwise, the commands will be executed synchronously.
  await cmd.executeThread();
}