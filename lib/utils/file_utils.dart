import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<void> agregarImagenAlRequest({
  required http.MultipartRequest request,
  required String fieldName,
  required String path,
}) async {
  final file = File(path);

  if (!file.existsSync()) return;

  final mimeType = _getMimeType(path);

  request.files.add(
    await http.MultipartFile.fromPath(
      fieldName,
      path,
      contentType: MediaType('image', mimeType),
    ),
  );
}

String _getMimeType(String path) {
  final ext = path.split('.').last.toLowerCase();
  switch (ext) {
    case 'jpg':
    case 'jpeg':
      return 'jpeg';
    case 'png':
      return 'png';
    default:
      return 'jpeg';
  }
}
