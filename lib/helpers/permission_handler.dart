import 'package:permission_handler/permission_handler.dart';

/// Returns a Future that resolves to a boolean indicating whether the app has been granted permission to access external storage.
///
/// The function checks the status of the storage permission and returns true if it has been granted, false otherwise.
///
/// Example usage:
/// ```
/// bool isGranted = await storagePermissionGranted();
/// ```
Future<bool> storagePermissionGranted() async {
  return await Permission.storage.status.isGranted;
}

/// Requests storage permission and returns a boolean indicating whether the permission is granted or not.
/// Returns `true` if the permission is granted, `false` otherwise.
Future<bool> requestStoragePermission() async {
  var status = await Permission.storage.request();
  return status.isGranted;
}
