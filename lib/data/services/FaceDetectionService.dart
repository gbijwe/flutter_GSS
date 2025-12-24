// import 'dart:io';
// import 'dart:typed_data';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;

// class FaceDetectionService {
//   // Update model path and parameters based on your actual detection model
//   static const String MODEL_PATH = 'assets/models/face_detection.tflite'; // e.g., MTCNN, BlazeFace, etc.
//   static const int INPUT_SIZE = 160; // Adjust based on your model's input size
//   static const double CONFIDENCE_THRESHOLD = 0.7;
//   static const double CROP_PADDING = 0.2;
  
//   Interpreter? _interpreter;
  
//   Future<void> initialize() async {
//     _interpreter = await Interpreter.fromAsset(MODEL_PATH);
    
//     // Print input/output tensor shapes to verify
//     print('Input shape: ${_interpreter!.getInputTensor(0).shape}');
//     print('Output tensors: ${_interpreter!.getOutputTensors().map((t) => t.shape).toList()}');
//   }
  
//   Future<List<FaceDetection>> detectFaces(File imageFile) async {
//     if (_interpreter == null) {
//       throw StateError('Face detection service not initialized');
//     }
    
//     final imageBytes = await imageFile.readAsBytes();
//     final image = img.decodeImage(imageBytes);
//     if (image == null) return [];
    
//     final resized = img.copyResize(image, width: INPUT_SIZE, height: INPUT_SIZE);
//     final input = _imageToByteList(resized);
    
//     // ADJUST OUTPUT BUFFERS BASED ON YOUR MODEL
//     // Check your model's output shape and format
//     // Common formats:
//     // - [1, num_detections, 4] for boxes
//     // - [1, num_detections] for scores
//     // - [1, num_detections, num_classes] for class scores
    
//     final outputBoxes = List.filled(1 * 10 * 4, 0.0).reshape([1, 10, 4]); // Example: max 10 faces
//     final outputScores = List.filled(1 * 10, 0.0).reshape([1, 10]);
    
//     _interpreter!.run(input, {0: outputBoxes, 1: outputScores});
    
//     // ADJUST PARSING BASED ON YOUR MODEL'S OUTPUT FORMAT
//     final detections = <FaceDetection>[];
    
//     for (int i = 0; i < 10; i++) {
//       final score = outputScores[0][i];
//       if (score > CONFIDENCE_THRESHOLD) {
//         final box = outputBoxes[0][i];
        
//         // Convert normalized coordinates to pixel coordinates
//         // Adjust based on your model's coordinate format (normalized vs absolute, yxyx vs xyxy, etc.)
//         final left = (box[1] * image.width).clamp(0, image.width).toInt();
//         final top = (box[0] * image.height).clamp(0, image.height).toInt();
//         final right = (box[3] * image.width).clamp(0, image.width).toInt();
//         final bottom = (box[2] * image.height).clamp(0, image.height).toInt();
        
//         detections.add(FaceDetection(
//           box: FaceBox(left: left, top: top, right: right, bottom: bottom),
//           confidence: score,
//           imageWidth: image.width,
//           imageHeight: image.height,
//         ));
//       }
//     }
    
//     return detections;
//   }
  
//   img.Image cropFace(img.Image image, FaceBox box, {double padding = CROP_PADDING}) {
//     final paddingWidth = (box.width * padding).toInt();
//     final paddingHeight = (box.height * padding).toInt();
    
//     final paddedLeft = (box.left - paddingWidth).clamp(0, image.width);
//     final paddedTop = (box.top - paddingHeight).clamp(0, image.height);
//     final paddedRight = (box.right + paddingWidth).clamp(0, image.width);
//     final paddedBottom = (box.bottom + paddingHeight).clamp(0, image.height);
    
//     final cropWidth = paddedRight - paddedLeft;
//     final cropHeight = paddedBottom - paddedTop;
    
//     return img.copyCrop(
//       image,
//       x: paddedLeft,
//       y: paddedTop,
//       width: cropWidth,
//       height: cropHeight,
//     );
//   }
  
//   Future<List<CroppedFace>> detectAndCropFaces(File imageFile) async {
//     final imageBytes = await imageFile.readAsBytes();
//     final image = img.decodeImage(imageBytes);
//     if (image == null) return [];
    
//     final detections = await detectFaces(imageFile);
//     final croppedFaces = <CroppedFace>[];
    
//     for (final detection in detections) {
//       final croppedImage = cropFace(image, detection.box);
//       croppedFaces.add(CroppedFace(
//         image: croppedImage,
//         detection: detection,
//       ));
//     }
    
//     return croppedFaces;
//   }
  
//   Float32List _imageToByteList(img.Image image) {
//     final buffer = Float32List(1 * INPUT_SIZE * INPUT_SIZE * 3);
//     int pixelIndex = 0;
    
//     for (int y = 0; y < INPUT_SIZE; y++) {
//       for (int x = 0; x < INPUT_SIZE; x++) {
//         final pixel = image.getPixel(x, y);
//         // Adjust normalization based on your model's requirements
//         // Common formats: [0, 1], [-1, 1], [0, 255]
//         buffer[pixelIndex++] = (pixel.r / 127.5) - 1.0;
//         buffer[pixelIndex++] = (pixel.g / 127.5) - 1.0;
//         buffer[pixelIndex++] = (pixel.b / 127.5) - 1.0;
//       }
//     }
    
//     return buffer;
//   }
  
//   void dispose() {
//     _interpreter?.close();
//     _interpreter = null;
//   }
// }

// class FaceDetection {
//   final FaceBox box;
//   final double confidence;
//   final int imageWidth;
//   final int imageHeight;
  
//   FaceDetection({
//     required this.box,
//     required this.confidence,
//     required this.imageWidth,
//     required this.imageHeight,
//   });
// }

// class FaceBox {
//   final int left;
//   final int top;
//   final int right;
//   final int bottom;
  
//   FaceBox({
//     required this.left,
//     required this.top,
//     required this.right,
//     required this.bottom,
//   });
  
//   int get width => right - left;
//   int get height => bottom - top;
// }

// class CroppedFace {
//   final img.Image image;
//   final FaceDetection detection;
  
//   CroppedFace({
//     required this.image,
//     required this.detection,
//   });
// }