import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

Future<CameraController> initCameraController() async {
  final cameras = await availableCameras();
  final cameraController = CameraController(
    cameras.first,
    ResolutionPreset.high,
  );
  await cameraController.initialize();
  return cameraController;
}
