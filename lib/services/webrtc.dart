import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  static Future<RTCSessionDescription> createOffer(
      RTCPeerConnection peerConnection) async {
    final RTCSessionDescription description =
        await peerConnection.createOffer({'offerToReceiveVideo': 1});

    peerConnection.setLocalDescription(description);

    debugPrint('Local description: ${description.sdp}');

    return description;
  }

  static Future<RTCSessionDescription> createAnswer(
      RTCPeerConnection peerConnection) async {
    final RTCSessionDescription description =
        await peerConnection.createAnswer({'offerToReceiveVideo': 1});

    peerConnection.setLocalDescription(description);

    debugPrint('Local description: ${description.sdp}');

    return description;
  }

  static Future<void> setRemoteDescription(
      RTCPeerConnection peerConnection, String sdp) async {
    final Map<String, dynamic> session = jsonDecode(sdp);
    final RTCSessionDescription description =
        RTCSessionDescription(session['sdp'], session['type']);

    peerConnection.setRemoteDescription(description);

    debugPrint('Remote description: $session');
  }
}
