import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class FaceEmbeddingService {
  static const String MODEL_PATH = 'assets/models/facenet.tflite';
  static const int INPUT_SIZE = 160;
  static const int EMBEDDING_SIZE = 512;
  
  Interpreter? _interpreter;
  
  Future<void> initialize() async {
    _interpreter = await Interpreter.fromAsset(MODEL_PATH);
    
    print('FaceNet Input shape: ${_interpreter!.getInputTensor(0).shape}');
    print('FaceNet Output shape: ${_interpreter!.getOutputTensor(0).shape}');
  }
  
  Future<List<double>> extractEmbeddingFromFile(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }
    
    return extractEmbedding(image);
  }
  
  Future<List<double>> extractEmbedding(img.Image faceImage) async {
    if (_interpreter == null) {
      throw StateError('Face embedding service not initialized');
    }
    
    final resized = img.copyResize(
      faceImage,
      width: INPUT_SIZE,
      height: INPUT_SIZE,
      interpolation: img.Interpolation.cubic,
    );
    
    final input = _preprocessImage(resized);
    final output = List.generate(1, (_) => List<double>.filled(EMBEDDING_SIZE, 0.0));
    
    _interpreter!.run(input, output);
    
    final embedding = List<double>.from(output[0]);
    return _normalizeEmbedding(embedding);
  }
  
  Future<List<ImageEmbedding>> extractEmbeddingsFromFiles(List<File> imageFiles) async {
    final embeddings = <ImageEmbedding>[];
    
    for (int i = 0; i < imageFiles.length; i++) {
      try {
        final embedding = await extractEmbeddingFromFile(imageFiles[i]);
        embeddings.add(ImageEmbedding(
          embedding: embedding,
          filePath: imageFiles[i].path,
          index: i,
        ));
      } catch (e) {
        print('Failed to extract embedding from ${imageFiles[i].path}: $e');
      }
    }
    
    return embeddings;
  }
  
  Float32List _preprocessImage(img.Image image) {
    final buffer = Float32List(1 * INPUT_SIZE * INPUT_SIZE * 3);
    int pixelIndex = 0;
    
    for (int y = 0; y < INPUT_SIZE; y++) {
      for (int x = 0; x < INPUT_SIZE; x++) {
        final pixel = image.getPixel(x, y);
        
        buffer[pixelIndex++] = (pixel.r - 127.5) / 128.0;
        buffer[pixelIndex++] = (pixel.g - 127.5) / 128.0;
        buffer[pixelIndex++] = (pixel.b - 127.5) / 128.0;
      }
    }
    
    return buffer;
  }
  
  List<double> _normalizeEmbedding(List<double> embedding) {
    double sumSquares = 0.0;
    for (final value in embedding) {
      sumSquares += value * value;
    }
    
    final magnitude = sumSquares > 0 ? 1.0 / math.sqrt(sumSquares) : 0.0;
    return embedding.map((value) => value * magnitude).toList();
  }
  
  double cosineSimilarity(List<double> embedding1, List<double> embedding2) {
    if (embedding1.length != embedding2.length) {
      throw ArgumentError('Embeddings must have the same length');
    }
    
    double dotProduct = 0.0;
    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
    }
    
    return dotProduct;
  }
  
  double cosineDistance(List<double> embedding1, List<double> embedding2) {
    return 1.0 - cosineSimilarity(embedding1, embedding2);
  }
  
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}

class ImageEmbedding {
  final List<double> embedding;
  final String filePath;
  final int index;
  
  ImageEmbedding({
    required this.embedding,
    required this.filePath,
    required this.index,
  });
}