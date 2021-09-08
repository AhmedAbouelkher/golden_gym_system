import 'dart:io';

import 'package:path/path.dart' as p;

//TODO: test on Windows
import 'package:path_provider/path_provider.dart' as path_provider;

Future<Directory> getApplicationImagesDirectory() async {
  final documentsDir = await path_provider.getApplicationDocumentsDirectory();
  if (Platform.isMacOS) {
    return documentsDir;
  }
  final imagesDir = await Directory(
    p.join(documentsDir.path, 'golden_gym', 'images'),
  ).create(recursive: true);
  return imagesDir;
}

Future<File?> copyImage(File image, {String? name}) async {
  try {
    var basename = p.basename(image.path);
    if (name != null) basename = '$name.${basename.split('.').last}';
    final dir = await getApplicationImagesDirectory();
    final newPath = p.join(dir.path, basename);
    return image.copy(newPath);
  } on Exception catch (e) {
    // ignore: avoid_print
    print(e);
    return null;
  }
}

Future<FileSystemEntity?> deleteImage(File image) async {
  try {
    return image.delete();
  } on Exception catch (e) {
    // ignore: avoid_print
    print(e);
    return null;
  }
}
