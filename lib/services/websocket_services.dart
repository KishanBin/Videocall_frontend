import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:videocall_app/config/appconfig.dart';
import 'package:videocall_app/controllers/storageService.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketServices extends GetxController {
  late String? toPhone;

  // String url = "//ec1b-2409-40c0-51-756f-29d0-c889-62ad-b080.ngrok-free.app";
  Appconfig wsUrl = Appconfig();

  late WebSocketChannel socket = WebSocketChannel.connect(
    Uri.parse("wss:${wsUrl.serverUrl}"),
  );

  //it Discover public IP
  final Map<String, dynamic> config = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
    ],
  };

  late RTCPeerConnection peerConnection;

  var storage = Get.find<StorageService>();

  late Map<String, dynamic> self;

  @override
  onInit() async {
    super.onInit();

    self = storage.user!;

    peerConnection = await createPeerConnection(config);

    //start block
    peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate == null || toPhone == null) return;

      final icePayload = {
        "type": "candidate",
        "from": self['phone'],
        "to": toPhone, // ⚠️ set dynamically (see note below)
        "candidate": candidate.toMap(),
      };

      socket.sink.add(jsonEncode(icePayload));
      print("📤 ICE candidate sent");
    };
    // End Block

    

    try {
      socket.stream.listen(
        messages,
        onError: (error) {
          print("Websocket error: $error");
        },
        onDone: () {
          print("Websocket Connection is Closed!");
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  void setData(String to){
     toPhone = to;
  }

  void messages(dynamic data) {
    final decoded = jsonDecode(data);

    print("received: $decoded");

    switch (decoded['type']) {
      case 'connected':
        print(decoded['message']);
        Get.find<StorageService>().setWSconnected(true);
        break;

      case 'registered':
        print(decoded['message']);
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

  //register the user
  void registerUser(Map userData) {
    var register = {
      "type": "register",
      "username" : userData['username'],
      "phone" : userData['phone']
    };
    socket.sink.add(jsonEncode(register));
  }

  //sendOffer to Other User
  Future<void> createAndSendOffer(from, to) async {
    // Create offer
    var offer = await peerConnection.createOffer();

    // Set local description (CRITICAL)
    await peerConnection.setLocalDescription(offer);

    //offer data
    Map offerData = {
      "type": "offer",
      "from": from,
      "to": to,
      "offer": offer.toMap(),
    };

    socket.sink.add(jsonEncode(offerData));
  }

  Future<void> createAndSendAnswer(Map<String, dynamic> offer) async {
    // 1️⃣ Set remote description (offer)
    await peerConnection.setRemoteDescription(
      RTCSessionDescription(
        offer['offer']['sdp'],
        offer['offer']['type'], // "offer"
      ),
    );

    // 2️⃣ Create answer
    RTCSessionDescription answer = await peerConnection.createAnswer();

    // 3️⃣ Set local description
    await peerConnection.setLocalDescription(answer);

    Map<dynamic, dynamic> payload = {
      "type": "answer",
      "from": self['phone'],
      "to": offer['from'],
      "answer": answer.toMap(),
    };

    socket.sink.add(jsonEncode(payload));
  }

  Future<void> handleAnswer(Map<String, dynamic> answer) async {
    try {
      // 1️⃣ Convert JSON to RTCSessionDescription
      RTCSessionDescription remoteAnswer = RTCSessionDescription(
        answer['answer']['sdp'], // <-- match your server payload
        answer['answer']['type'], // "answer"
      );

      // 2️⃣ Apply remote answer
      await peerConnection.setRemoteDescription(remoteAnswer);

      print("✅ Answer applied. Connection is now stable.");
    } catch (e) {
      print("❌ Error handling answer: $e");
    }
  }

  Future<void> handleCandidate(Map<String, dynamic> data) async {
    try {
      final candidateMap = data['candidate'];

      RTCIceCandidate candidate = RTCIceCandidate(
        candidateMap['candidate'],
        candidateMap['sdpMid'],
        candidateMap['sdpMLineIndex'],
      );

      await peerConnection.addCandidate(candidate);
      print("📥 ICE candidate added");
    } catch (e) {
      print("❌ Error adding ICE candidate: $e");
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    socket.sink.close();
    Get.find<StorageService>().setWSconnected(false);
  }
}
