// file_service.dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class FileService {
  Future<File?> pickFile({List<String>? allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: allowedExtensions,
    );
    
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
  
  Future<String?> readFileAsString(File file) async {
    try {
      return await file.readAsString();
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> saveFile(String content, String fileName) async {
    try {
      String? path = await FilePicker.platform.getDirectoryPath();
      
      if (path != null) {
        final file = File('$path/$fileName');
        await file.writeAsString(content);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  // Parse Draw.io XML file
  Future<Map<String, dynamic>?> parseDrawIoFile(File file) async {
    try {
      String content = await file.readAsString();
      
      // Simple parsing logic - in a real app, you'd need a more robust parser
      if (content.contains('<mxGraphModel')) {
        // Extract cells from the Draw.io XML
        // This is a simplified example
        return {
          'type': 'drawio',
          'content': content,
          // Further parsing would happen here
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }



  // Convert ERD to Draw.io XML format
  String convertToDrawIoFormat(Map<String, dynamic> erDiagram) {
    // This is a simplified example - in a real app, you'd need a more robust converter
    String drawIoContent = '<mxGraphModel>\n';
    
    for (var entity in erDiagram['entities']) {
      drawIoContent += '<mxCell id="${entity['id']}" value="${entity['name']}" />\n';
    }
    
    drawIoContent += '</mxGraphModel>';
    return drawIoContent;
  }

  // Convert ERD to JSON format
  String convertToJsonFormat(Map<String, dynamic> erDiagram) {
    return jsonEncode(erDiagram);
  }
}