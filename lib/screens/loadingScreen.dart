
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:videocall_app/controllers/loadingScreenController.dart';

class LoadingScreen extends GetView<Loadingscreencontroller>{
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context){

  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator()
        ],
      ),
    ),
  );
    
  }

}