import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash.dart';
import 'constant.dart';
import 'faceDetection1.dart';

//import 'view/faceDetection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FaceDetectionState())
        ],
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Electronic AC',
            theme: ThemeData(
              scaffoldBackgroundColor: kBackgroundColor,
              primaryColor: kPrimaryColor,
              textTheme:
                  Theme.of(context).textTheme.apply(bodyColor: kTextColor),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: SplashScreen(),
          );
        });
  }
}
