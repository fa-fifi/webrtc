import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webrtc/screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint = (String? message, {int? wrapWidth}) => debugPrintSynchronously(
      '[${DateTime.now()}] $message',
      wrapWidth: wrapWidth);
  runApp(const WebRTC());
}

class WebRTC extends StatelessWidget {
  const WebRTC({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'WebRTC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.grey,
              brightness: MediaQuery.platformBrightnessOf(context))),
      home: const HomeScreen());
}
