import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CardScannerPage extends StatefulWidget {
  @override
  _CardScannerPageState createState() => _CardScannerPageState();
}

class _CardScannerPageState extends State<CardScannerPage> {
  CameraController? cameraController;
  final textRecognizer = GoogleMlKit.vision.textRecognizer();
  bool isProcessing = false;
  String cardNumber = '';
  String expiryDate = '';

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high, // Use the highest resolution available
      imageFormatGroup: ImageFormatGroup.yuv420, // Use a format suitable for text recognition
    );
    await cameraController?.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    cameraController?.dispose();
    textRecognizer.close();
    super.dispose();
  }

  Future<void> scanCard() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      if (isProcessing) return;

      setState(() {
        isProcessing = true;
      });

      try {
        final picture = await cameraController!.takePicture();
        final inputImage = InputImage.fromFilePath(picture.path);
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

        String? detectedCardNumber;
        String? detectedExpiryDate;

        for (TextBlock block in recognizedText.blocks) {
          for (TextLine line in block.lines) {
            final text = line.text.replaceAll(' ', '');
            if (RegExp(r'^[0-9]{13,19}$').hasMatch(text)) {
              detectedCardNumber = text;
            } else if (RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(line.text)) {
              detectedExpiryDate = line.text;
            }
          }
        }

        if (detectedCardNumber != null) {
          setState(() {
            cardNumber = detectedCardNumber!;
          });
        }

        if (detectedExpiryDate != null) {
          setState(() {
            expiryDate = detectedExpiryDate!;
          });
        }

        if (detectedCardNumber != null && detectedExpiryDate != null) {
          Navigator.pop(context, {
            'cardNumber': cardNumber,
            'expiryDate': expiryDate,
          });
        } else {
          _showError('Failed to detect card details. Please try again.');
        }
      } catch (e) {
        print('Error scanning card: $e');
        _showError('Error scanning card. Please try again.');
      } finally {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text('Scan Card')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Scan Card')),
      body: Stack(
        children: [
          CameraPreview(cameraController!),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: scanCard,
              child: Text('Scan'),
            ),
          ),
        ],
      ),
    );
  }
}
