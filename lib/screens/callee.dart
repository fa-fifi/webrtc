import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' hide VideoRenderer;
import 'package:webrtc/services/webrtc.dart';
import 'package:webrtc/widgets/flat_button.dart';
import 'package:webrtc/widgets/custom_tile.dart';
import 'package:webrtc/widgets/video_renderer.dart';

class CalleeScreen extends StatefulWidget {
  final RTCPeerConnection peerConnection;

  const CalleeScreen({super.key, required this.peerConnection});

  @override
  State<CalleeScreen> createState() => _CalleeScreenState();
}

class _CalleeScreenState extends State<CalleeScreen> {
  Future<void> _copyAnswer() async {
    final Map<String, dynamic> session =
        (await WebRTCService.createAnswer(widget.peerConnection)).toMap();

    Clipboard.setData(ClipboardData(text: jsonEncode(session))).whenComplete(
        () => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
              const SnackBar(content: Text('Copied to clipboard.'))));
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Callee')),
          body: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VideoRenderer(peerConnection: widget.peerConnection),
                  CustomTile(
                      onPressed: (controller) =>
                          WebRTCService.setRemoteDescription(
                              widget.peerConnection, controller.text),
                      title: 'Step 1',
                      subtitle:
                          'Paste the offer you receive from the caller below.',
                      label: 'Submit'),
                  ListTile(
                      title: const Text('Step 2'),
                      subtitle: const Text(
                          'Create an answer and send it to the caller.'),
                      trailing:
                          FlatButton(onPressed: _copyAnswer, label: 'Create')),
                ]),
          ),
        ),
      );
}
