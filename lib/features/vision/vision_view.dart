// lib/features/vision/vision_view.dart
import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'vision_controller.dart';
import 'damage_painter.dart'; 

class VisionView extends StatefulWidget {
  const VisionView({super.key});

  @override
  State<VisionView> createState() => _VisionViewState();
}

class _VisionViewState extends State<VisionView> {
  late VisionController _visionController;
  Timer? _mockTimer;
  
  double _mockX = 0.5; 
  double _mockY = 0.5;
  
  // Data label dan skor simulasi AI
  String _mockLabel = "D40 POTHOLE";
  int _mockScore = 92;

  @override
  void initState() {
    super.initState();
    _visionController = VisionController();
    _startMockDetection(); 
  }

  void _startMockDetection() {
    _mockTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _mockX = 0.2 + Random().nextDouble() * 0.6; 
          _mockY = 0.2 + Random().nextDouble() * 0.6;
          
          bool isPothole = Random().nextBool();
          _mockLabel = isPothole ? "D40 POTHOLE" : "D00 CRACK";
          _mockScore = 75 + Random().nextInt(20); 
        });
      }
    });
  }

  @override
  void dispose() {
    _mockTimer?.cancel();
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
        ),
        backgroundColor: const Color(0xFF243C2C),
        foregroundColor: const Color(0xFFECE69D),
        actions: [
          ListenableBuilder(
            listenable: _visionController,
            builder: (context, child) {
              return Row(
                children: [
                  IconButton(
                    icon: Icon(_visionController.isOverlayActive ? Icons.visibility : Icons.visibility_off),
                    onPressed: _visionController.toggleOverlay,
                    tooltip: "Toggle Overlay",
                  ),
                  IconButton(
                    icon: Icon(_visionController.isFlashOn ? Icons.flash_on : Icons.flash_off),
                    color: _visionController.isFlashOn ? Colors.yellow : null,
                    onPressed: _visionController.toggleFlash,
                    tooltip: "Toggle Flashlight",
                  ),
                ],
              );
            }
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _visionController,
        builder: (context, child) {
          if (_visionController.errorMessage != null) {
            return Center(
              child: Text(
                _visionController.errorMessage!, 
                style: const TextStyle(color: Colors.red)
              )
            );
          }
          
          if (!_visionController.isInitialized || _visionController.controller == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFFECE69D)),
                  SizedBox(height: 16),
                  Text(
                    "Menghubungkan ke Sensor Visual...",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            );
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

              // LAYER 2: Digital Overlay 
              if (_visionController.isOverlayActive)
                Positioned.fill(
                  child: CustomPaint(
                    painter: DamagePainter(
                      aiX: _mockX,
                      aiY: _mockY,
                      label: _mockLabel,
                      confidence: _mockScore,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}