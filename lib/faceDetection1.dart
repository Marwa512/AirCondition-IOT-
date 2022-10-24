// ignore: file_names
// ignore_for_file: prefer_const_constructors, file_names, unnecessary_new

import 'package:flutter/material.dart';
import 'package:learning_face_detection/learning_face_detection.dart';
import 'package:learning_input_image/learning_input_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BluetoothApp.dart';

// ignore: must_be_immutable
class FaceDetectionPage extends StatefulWidget {
  String title;
  @override
  _FaceDetectionPageState createState() =>
      _FaceDetectionPageState(title: title);
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  String title;
  _FaceDetectionPageState({this.title});
  FaceDetectionState get state => Provider.of(context, listen: false);

  FaceDetector _detector = FaceDetector(
    mode: FaceDetectorMode.accurate,
    detectLandmark: true,
    detectContour: true,
    enableClassification: true,
    enableTracking: true,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _detector.dispose();
    super.dispose();
  }

  Future<void> _detectFaces(InputImage image) async {
    Future.delayed(Duration(seconds: state.period)).then((value) async {
      if (state.isNotProcessing) {
        state.startProcessing();
        state.image = image;
        state.data = await _detector.detect(image);
        state.stopProcessing();
      }
      print(state._data.length.toString());
      BluetoothApp.sendToArd(state._data.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return InputCameraView(
      title: 'Face Detection',
      onImage: _detectFaces,
      overlay: Consumer<FaceDetectionState>(
        builder: (_, state, __) {
          if (state.isEmpty) {
            return Center(
              child: Text(
                "0 Person",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            );
          }
          return Center(
            child: Text(state.data.length.toString() + " Persons",
                style: TextStyle(fontSize: 24, color: Colors.white)),
          );

          // ignore: dead_code
          Size originalSize = state.size;
          Size size = MediaQuery.of(context).size;

          // if image source from gallery
          // image display size is scaled to 360x360 with retaining aspect ratio
          if (state.notFromLive) {
            if (originalSize.aspectRatio > 1) {
              size = Size(360.0, 360.0 / originalSize.aspectRatio);
            } else {
              size = Size(360.0 * originalSize.aspectRatio, 360.0);
            }
          }

          return FaceOverlay(
            size: size,
            originalSize: originalSize,
            rotation: state.rotation,
            faces: state.data,
            contourColor: Colors.white.withOpacity(0.8),
            landmarkColor: Colors.lightBlue.withOpacity(0.8),
          );
        },
      ),
    );
  }
}

class FaceDetectionState extends ChangeNotifier {
  FaceDetectionState() {
    print("-----(" + period.toString() + ")-----");
    read();
  }
  int period = 10;
  Future<void> read() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    period = prefs.getInt('period') ?? 10;
    print("-----(" + period.toString() + ")-----");
  }

  InputImage _image;
  List<Face> _data = [];
  bool _isProcessing = false;
  InputImage get image => _image;
  List<Face> get data => _data;
  String get type => _image?.type;
  InputImageRotation get rotation => _image?.metadata?.rotation;
  Size get size => _image?.metadata?.size;
  bool get isNotProcessing => !_isProcessing;
  bool get isEmpty => data.isEmpty;
  bool get isFromLive => type == 'bytes';
  bool get notFromLive => !isFromLive;
  void startProcessing() {
    _isProcessing = true;
    notifyListeners();
  }

  void stopProcessing() {
    _isProcessing = false;
    notifyListeners();
  }

  set image(InputImage image) {
    _image = image;

    if (notFromLive) {
      _data = [];
    }
    notifyListeners();
  }

  set data(List<Face> data) {
    _data = data;
    notifyListeners();
  }
}
