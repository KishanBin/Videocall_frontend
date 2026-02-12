

import 'package:get/get.dart';
import 'package:videocall_app/controllers/loadingScreenController.dart';

class LoadingScreenBinding implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(Loadingscreencontroller());
  }

}