// lib/utils/web_utils.dart

import 'dart:typed_data';
import 'dart:html' as html;

void downloadTextWeb(String text, String filename) {
  final bytes = Uint8List.fromList(text.codeUnits);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}

html.FormData createFormData(Uint8List fileBytes, String fileName) {
  final blob = html.Blob([fileBytes]);
  final file = html.File([blob], fileName);
  final formData = html.FormData();
  formData.appendBlob('file', file, fileName);
  return formData;
}

html.HttpRequest createRequest(String url) {
  final request = html.HttpRequest();
  request.open('POST', url);
  return request;
}
