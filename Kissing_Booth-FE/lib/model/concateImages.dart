import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Converts an image from `Uint8List` to a JPEG format and saves it as a temporary file.
/// Returns the saved `File` object.
File convertToJpgFile(Uint8List byteData, {bool skipIfAlreadyJpg = true}) {
  // Check if the input is already JPEG
  if (skipIfAlreadyJpg) {
    final String header =
        byteData.sublist(0, 2).map((e) => e.toRadixString(16)).join();
    if (header == 'ffd8') {
      print("Input file is already a JPEG. Skipping conversion.");
      // Create a temporary file to save the original data
      File tempFile = File(
          '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg');
      tempFile.writeAsBytesSync(byteData);
      print(
          "Final file size: ${tempFile.lengthSync()} bytes (${(tempFile.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB)");
      return tempFile;
    }
  }

  // Decode the image data
  img.Image? decodedImage = img.decodeImage(byteData);
  if (decodedImage == null) {
    throw Exception("Failed to decode the image.");
  }

  // Encode the image to JPEG format
  Uint8List compressedData = Uint8List.fromList(img.encodeJpg(decodedImage));

  // Create a temporary file
  File tempFile = File(
      '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg');

  // Write the compressed JPEG data to the temporary file
  tempFile.writeAsBytesSync(compressedData);

  print(
      "Converted JPG file size: ${tempFile.lengthSync()} bytes (${(tempFile.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB)");

  return tempFile;
}
