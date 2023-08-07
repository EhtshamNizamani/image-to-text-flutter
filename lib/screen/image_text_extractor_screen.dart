import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:image_picker/image_picker.dart';

class ImageTextExtractorScreen extends StatefulWidget {
  const ImageTextExtractorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageTextExtractorScreenState createState() =>
      _ImageTextExtractorScreenState();
}

class _ImageTextExtractorScreenState extends State<ImageTextExtractorScreen> {
  String extractedText = '';

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String imagePath = pickedFile.path;
      extractTextFromImage(imagePath);
    }
  }

  Future<void> extractTextFromImage(String imagePath) async {
    try {
      String extractedText = await FlutterTesseractOcr.extractText(
        imagePath,
        language: 'kor+eng',
      );

      setState(() {
        this.extractedText = extractedText;
      });
    } on PlatformException catch (e) {
      setState(() {
        this.extractedText = 'Error: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Text Extractor'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: Text('Select Image'),
              ),
              SizedBox(height: 20),
              Text(
                'Extracted Text:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(extractedText),
            ],
          ),
        ),
      ),
    );
  }
}
