import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' hide VideoRenderer;
import 'package:webrtc/services/webrtc.dart';
import 'package:webrtc/widgets/flat_button.dart';
import 'package:webrtc/widgets/loading_indicator.dart';
import 'package:webrtc/widgets/custom_tile.dart';
import 'package:webrtc/widgets/video_renderer.dart';

class CallerScreen extends StatefulWidget {
  final RTCPeerConnection peerConnection;

  const CallerScreen({super.key, required this.peerConnection});

  @override
  State<CallerScreen> createState() => _CallerScreenState();
}

class _CallerScreenState extends State<CallerScreen> {
  late final StreamController<RTCIceGatheringState> _streamController =
      StreamController(
          onListen: () => widget.peerConnection.onIceGatheringState =
              (state) => _streamController.add(state));

  Future<void> _copyOffer() async {
    final Map<String, dynamic> session =
        (await WebRTCService.createOffer(widget.peerConnection)).toMap();

    Clipboard.setData(ClipboardData(text: jsonEncode(session))).whenComplete(
        () => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
              const SnackBar(content: Text('Copied to clipboard.'))));
  }

  @override
  void initState() {
    WebRTCService.createOffer(widget.peerConnection);
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Caller')),
          body: Column(children: [
            VideoRenderer(peerConnection: widget.peerConnection),
            StreamBuilder<RTCIceGatheringState>(
                stream: _streamController.stream,
                builder: (context, snapshot) => snapshot.data ==
                        RTCIceGatheringState.RTCIceGatheringStateComplete
                    ? SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ListTile(
                                title: const Text('Step 1'),
                                subtitle: const Text(
                                    'Create an offer and send it to the callee.'),
                                trailing: FlatButton(
                                    onPressed: _copyOffer, label: 'Create'),
                              ),
                              CustomTile(
                                  onPressed: (controller) =>
                                      WebRTCService.setRemoteDescription(
                                          widget.peerConnection,
                                          controller.text),
                                  title: 'Step 2',
                                  subtitle:
                                      'Paste the answer you receive from the callee below.',
                                  label: 'Submit'),
                            ]),
                      )
                    : const Flexible(
                        child: LoadingIndicator(
                            text: 'Gathering ICE candidates...'))),
          ]),
        ),
      );
}
