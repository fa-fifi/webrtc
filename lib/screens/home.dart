import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:webrtc/screens/callee.dart';
import 'package:webrtc/screens/caller.dart';
import 'package:webrtc/widgets/flat_button.dart';
import 'package:webrtc/widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<RTCPeerConnection> _createPeerConnection = createPeerConnection({
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      {'url': 'stun:stun.l.google.com:19305'},
      {'url': 'stun:stun1.l.google.com:19302'},
      {'url': 'stun:stun1.l.google.com:19305'},
      {'url': 'stun:stun2.l.google.com:19302'},
      {'url': 'stun:stun2.l.google.com:19305'},
      {'url': 'stun:stun3.l.google.com:19302'},
      {'url': 'stun:stun3.l.google.com:19305'},
      {'url': 'stun:stun4.l.google.com:19302'},
      {'url': 'stun:stun4.l.google.com:19305'},
    ],
  }, {
    'mandatory': {'OfferToReceiveAudio': true, 'OfferToReceiveVideo': true},
    'optional': [],
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('WebRTC'),
              const SizedBox(width: 5),
              Image.asset('assets/icon.png', height: 25),
            ])),
        body: FutureBuilder<RTCPeerConnection>(
            future: _createPeerConnection,
            builder: (context, snapshot) => snapshot.hasData
                ? Column(mainAxisSize: MainAxisSize.min, children: [
                    const Spacer(),
                    Image.asset('assets/multidevice.png',
                        width: MediaQuery.of(context).size.shortestSide * 0.8),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.shortestSide * 0.05),
                      child: Text(
                          'Open this application on two different browsers or devices side by side and follow the following steps. Choose either to be the caller or the callee.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(children: [
                        Expanded(
                          child: FlatButton(
                              onPressed: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CallerScreen(
                                        peerConnection: snapshot.data!),
                                  )),
                              label: 'Caller'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FlatButton(
                              onPressed: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CalleeScreen(
                                        peerConnection: snapshot.data!),
                                  )),
                              label: 'Callee'),
                        ),
                      ]),
                    ),
                  ])
                : const LoadingIndicator(text: 'Creating peer connection...')),
      );
}
