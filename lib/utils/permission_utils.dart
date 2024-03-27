import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> getactivityRecognitionStatus() async {
    PermissionStatus activityRecognitionStatus =
        await Permission.activityRecognition.status;
    // PermissionStatus microphoneStatus = await Permission.microphone.status;
    if (activityRecognitionStatus.isGranted) {
      return true;
    }
    return false;
  }

  /// Requests permissions and returns `true` if granted.
  static Future<bool> askForPermission() async {
    // Request camera and microphone permissions
    Map<Permission, PermissionStatus> status = await [
      Permission.activityRecognition,
      // Permission.microphone,
    ].request();

    // Check if permissions are granted
    if (status[Permission.activityRecognition]!.isGranted) {
      return true;
    }
    return false;
  }
}
