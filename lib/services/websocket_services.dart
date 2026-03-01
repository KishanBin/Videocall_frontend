import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:videocall_app/config/appconfig.dart';
import 'package:videocall_app/controllers/storageService.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketServices extends GetxController {
  final Appconfig wsUrl = Appconfig();
  final storage = Get.find<StorageService>();

  late WebSocketChannel socket;
  late Map<String, dynamic> self;
  RTCPeerConnection? peerConnection;

  final Map<String, dynamic> config = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
    ],
  };

  @override
  void onInit() {
    super.onInit();

    if (storage.user != null) {
      self = storage.user!;
    }
    try {
      socket = WebSocketChannel.connect(Uri.parse("wss:${wsUrl.serverUrl}"));

      socket.stream.listen(
        messages,
        onError: (error) => print("WebSocket error: $error"),
        onDone: () => print("WebSocket closed"),
      );
    } catch (e) {
      print("Error $e");
    }
  }

  // ===============================
  // MESSAGE HANDLER
  // ===============================

  void messages(dynamic data) {
    final decoded = jsonDecode(data);

    switch (decoded['type']) {
      case 'connected':
        storage.setWSconnected(true);
        break;

      case 'offer':
        createAndSendAnswer(decoded);
        break;

      case 'answer':
        handleAnswer(decoded);
        break;

      case 'candidate':
        handleCandidate(decoded);
        break;
    }
  }

  // ===============================
  // INIT PEER
  // ===============================

  Future<void> _initPeerConnection(String toPhone) async {
    peerConnection = await createPeerConnection(config);

    peerConnection!.onIceConnectionState = (state) {
      print("ICE State: $state");
      if (state == RTCIceConnectionState.RTCIceConnectionStateConnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateCompleted) {
        print("🎉 CALL CONNECTED");
      }
      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        print("❌ CALL FAILED");
      }
      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        print("⚠️ CALL DISCONNECTED");
      }
    };

    peerConnection!.onIceCandidate = (candidate) {
      if (candidate.candidate == null) return;

      socket.sink.add(
        jsonEncode({
          "type": "candidate",
          "from": self['phone'],
          "to": toPhone,
          "candidate": candidate.toMap(),
        }),
      );
    };
  }

  // ===============================
  // REGISTER
  // ===============================

  void registerUser(Map userData) {
    socket.sink.add(
      jsonEncode({
        "type": "register",
        "username": userData['username'],
        "phone": userData['phone'],
      }),
    );
  }

  // ===============================
  // CREATE OFFER (Caller)
  // ===============================

  Future<void> createAndSendOffer(String from, String to) async {
    await _initPeerConnection(to);

    final offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);

    socket.sink.add(
      jsonEncode({
        "type": "offer",
        "from": from,
        "to": to,
        "offer": offer.toMap(),
      }),
    );
  }

  // ===============================
  // CREATE ANSWER (Receiver)
  // ===============================

  Future<void> createAndSendAnswer(Map<String, dynamic> offer) async {
    final String callerPhone = offer['from'];

    await _initPeerConnection(callerPhone);

    await peerConnection!.setRemoteDescription(
      RTCSessionDescription(offer['offer']['sdp'], offer['offer']['type']),
    );

    final answer = await peerConnection!.createAnswer();
    await peerConnection!.setLocalDescription(answer);

    socket.sink.add(
      jsonEncode({
        "type": "answer",
        "from": self['phone'],
        "to": callerPhone,
        "answer": answer.toMap(),
      }),
    );
  }

  // ===============================
  // HANDLE ANSWER
  // ===============================

  Future<void> handleAnswer(Map<String, dynamic> answer) async {
    if (peerConnection == null) return;

    await peerConnection!.setRemoteDescription(
      RTCSessionDescription(answer['answer']['sdp'], answer['answer']['type']),
    );
  }

  // ===============================
  // HANDLE CANDIDATE
  // ===============================

  Future<void> handleCandidate(Map<String, dynamic> data) async {
    if (peerConnection == null) return;

    final candidateMap = data['candidate'];

    final candidate = RTCIceCandidate(
      candidateMap['candidate'],
      candidateMap['sdpMid'],
      candidateMap['sdpMLineIndex'],
    );

    await peerConnection!.addCandidate(candidate);
  }

  // ===============================
  // CLEANUP
  // ===============================

  @override
  void onClose() {
    peerConnection?.close();
    socket.sink.close();
    storage.setWSconnected(false);
    super.onClose();
  }
}
