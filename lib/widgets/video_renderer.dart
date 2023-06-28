import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoRenderer extends StatefulWidget {
  final RTCPeerConnection peerConnection;

  const VideoRenderer({super.key, required this.peerConnection});

  @override
  State<VideoRenderer> createState() => _VideoRendererState();
}

class _VideoRendererState extends State<VideoRenderer> {
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  Future<void> _initialization() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    final MediaStream stream = await navigator.mediaDevices
        .getUserMedia({'audio': true, 'video': true});

    stream
        .getTracks()
        .forEach((track) => widget.peerConnection.addTrack(track, stream));

    setState(() => localRenderer.srcObject = stream);

    widget.peerConnection.onAddStream = (stream) {
      debugPrint('Add Stream: ${stream.id}');
      remoteRenderer.srcObject = stream;
    };
  }

  Widget _buildVideoView(RTCVideoRenderer renderer, String label) => Flexible(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.black87),
          child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
            RTCVideoView(renderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(5)),
              child: Text(label,
                  style: Theme.of(context).primaryTextTheme.bodySmall),
            ),
          ]),
        ),
      );

  @override
  void initState() {
    _initialization();
    super.initState();
  }

  @override
  dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.of(context).size.longestSide / 3,
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
        margin: const EdgeInsets.all(5),
        child: Row(children: [
          _buildVideoView(localRenderer, 'Local'),
          const SizedBox(width: 5),
          _buildVideoView(remoteRenderer, 'Remote'),
        ]),
      );
}
