
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videocall_app/controllers/storageService.dart';
import 'package:videocall_app/services/websocket_services.dart';

class showDialogBoxController extends GetxController {
  final TextEditingController userName = TextEditingController();
  final TextEditingController phoneno = TextEditingController();
  
  final ws = Get.find<WebsocketServices>();


  show() {
    Get.dialog(
      AlertDialog(
        content: Container(
          height: Get.height * 0.25,
          child: Column(
            children: [
              Padding(padding: EdgeInsetsGeometry.fromSTEB(0, 10, 0, 0)),
              TextFormField(
                controller: userName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hint: Text('Username'),
                ),
              ),
              Spacer(),
              TextFormField(
                controller: phoneno,
                keyboardType: TextInputType.numberWithOptions(),
                maxLength: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hint: Text("phone no."),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("cancel")),
          TextButton(
            onPressed: () async {
              Map<String, dynamic> my = {
                'username': userName.text,
                'phone': phoneno.text,
              };

              if (userName.text.isNotEmpty && phoneno.text.isNotEmpty) {
                //save the user data in phone memory
                Get.find<StorageService>().saveUser(my);

                //make it true if user is saved
                Get.find<StorageService>().setHasUserData(true);
                
                ws.registerUser(my);
              } else {
                Get.find<showDialogBoxController>().show();
              }

              Get.back();
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  onClose() {
    super.onClose();
    userName.dispose();
    phoneno.dispose();
  }
}
