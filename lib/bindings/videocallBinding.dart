import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:videocall_app/controllers/videocallController.dart';

class Videocallbinding extends Bindings{
  @override
  void dependencies() {
    Get.put(Videocallcontroller());
    
  }

}