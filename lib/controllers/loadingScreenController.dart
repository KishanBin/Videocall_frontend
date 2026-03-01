import 'package:get/get.dart';
import 'package:videocall_app/controllers/storageService.dart';
import 'package:videocall_app/services/websocket_services.dart';

class Loadingscreencontroller extends GetxController {
  late String toPhone;
  late String toName;

  final ws = Get.find<WebsocketServices>();

  var storage = Get.find<StorageService>();

  late Map<String, dynamic> self;

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments;

    toPhone = args['phone'].replaceAll(' ',''); //replase is removing
    toPhone = toPhone.replaceFirst('+91','');
    toName = args['name'];
    self = storage.user!;
    
    sendOffer();
  }

  Future<void> sendOffer() async {
    //calling ws offer function
    ws.createAndSendOffer(self['phone'], toPhone);
  }
}
