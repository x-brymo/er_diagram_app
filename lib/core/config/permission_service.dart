// permission_service.dart
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    return status.isGranted;
  }
  
  Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    return status.isGranted;
  }
  
  Future<bool> hasStoragePermission() async {
    return await Permission.storage.isGranted;
  }


  Future<bool> hasCameraPermission() async {
    return await Permission.camera.isGranted;
  }
  
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }
}