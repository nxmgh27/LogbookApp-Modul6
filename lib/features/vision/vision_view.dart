// lib/features/vision/vision_view.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'vision_controller.dart';

class VisionView extends StatefulWidget {
  const VisionView({super.key});

  @override
  State<VisionView> createState() => _VisionViewState();
}

class _VisionViewState extends State<VisionView> {
  late VisionController _visionController;

  @override
  void initState() {
    super.initState();
    _visionController = VisionController();
  }

  @override
  void dispose() {
    _visionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: AppBar(
        leadingWidth: 40, 
        titleSpacing: 0,
        title: const Text(
          "Smart-Patrol Vision",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF243C2C),
        foregroundColor: const Color(0xFFECE69D),
      ),
      body: ListenableBuilder(
        listenable: _visionController,
        builder: (context, child) {
          if (_visionController.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _visionController.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
          
          if (!_visionController.isInitialized || _visionController.controller == null) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF243C2C)));
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // LAYER 1: Hardware Preview 
              Center(
                child: AspectRatio(
                  aspectRatio: 1 / _visionController.controller!.value.aspectRatio,
                  child: CameraPreview(_visionController.controller!),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}