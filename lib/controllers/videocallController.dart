import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videocall_app/controllers/storageService.dart';
// import 'package:videocall_app/services/websocket_services.dart';

class Videocallcontroller extends GetxController {


  @override
  onInit() {
    super.onInit();
    bool isWSconnected = Get.find<StorageService>().isWSconnected;
    if (isWSconnected) {
      //webRTC connection code
    } else {

      Get.snackbar(
        "Failed",
        "WebSocket is not connected!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.red,
      );
    }
  }
}
