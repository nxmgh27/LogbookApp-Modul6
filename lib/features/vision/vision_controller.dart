// lib/features/vision/vision_controller.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VisionController extends ChangeNotifier with WidgetsBindingObserver {
  CameraController? controller;
  bool isInitialized = false;
  String? errorMessage;

  // --- TAMBAHAN HOMEWORK ---
  bool isFlashOn = false;
  bool isOverlayActive = true; 

  VisionController() {
    WidgetsBinding.instance.addObserver(this);
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        errorMessage = "No camera detected on device.";
        notifyListeners();
        return;
      }

      controller = CameraController(
        cameras[0],
        ResolutionPreset.medium, 
        enableAudio: false,      
      );

      await controller!.initialize();
      
      // Pastikan flash mati saat awal
      await controller!.setFlashMode(FlashMode.off); 

      isInitialized = true;
      errorMessage = null;
    } catch (e) {
      errorMessage = "Failed to initialize camera: $e";
    }
    notifyListeners();
  }

  // --- TAMBAHAN HOMEWORK: Fungsi Toggle Flash ---
  Future<void> toggleFlash() async {
    if (controller == null || !isInitialized) return;
    try {
      if (isFlashOn) {
        await controller!.setFlashMode(FlashMode.off);
        isFlashOn = false;
      } else {
        await controller!.setFlashMode(FlashMode.torch); // Torch = Senter nyala terus
        isFlashOn = true;
      }
      notifyListeners();
    } catch (e) {
      print("Gagal menyalakan flash: $e");
    }
  }

  // --- TAMBAHAN HOMEWORK: Fungsi Toggle Overlay ---
  void toggleOverlay() {
    isOverlayActive = !isOverlayActive;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
      isInitialized = false;
      notifyListeners();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }
}