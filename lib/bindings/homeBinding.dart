import 'package:get/instance_manager.dart';
import 'package:videocall_app/controllers/homeController.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
   Get.put(Homecontroller());
  }

}