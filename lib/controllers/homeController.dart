import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videocall_app/controllers/storageService.dart';
import 'package:videocall_app/reusable/showDialog.dart';
import 'package:videocall_app/services/websocket_services.dart';

class Homecontroller extends GetxController {
  var contacts = <Contact>[].obs;
  RxList searchContactList = <Contact>[].obs;
  RxBool isSearch = false.obs;

  final ws = Get.find<WebsocketServices>();


  @override
  void onInit() {
    super.onInit();
    fetchContacts();
  }

  @override
  void onReady() {
    
    bool hasUserData = Get.find<StorageService>().hasUserData;

    if (!hasUserData) {
      Get.find<showDialogBoxController>().show();
    }else{
     Map<String, dynamic>? my = Get.find<StorageService>().user;
      ws.registerUser(my!);
    }
    
  }

  Future<List<Contact>> fetchContacts() async {
    bool contactPermission = await checkPermission();

    if (contactPermission) {
      // Get all contacts (lightly fetched)
      final fetchContacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );

      contacts.value = fetchContacts;
    }
    return contacts;
  }

  Future<bool> checkPermission() async {
    var status = await Permission.contacts.status;

    if (status.isDenied || status.isRestricted) {
      status = await Permission.contacts.request();
    }

    if (status.isDenied) {
      await openAppSettings();
      return false;
    }

    return status.isGranted;
  }

  void searchContact() {
    isSearch.toggle();
    searchContactList.clear();
  }

  @override
  void onClose() {
    searchContactList.clear();
    super.onClose();
  }
}
