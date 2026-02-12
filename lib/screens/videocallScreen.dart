import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videocall_app/controllers/videocallController.dart';

class Videocallscreen extends GetView<Videocallcontroller> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:Stack(
          children: [
            
            Positioned(
              right: 16,
              top: 32,
              child: Container(
                width: 120,
                height: 160,
                color: Colors.blue,
                child: Container(height: Get.height * 0.8,),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                       
                        Icons.abc
                      ),
                      onPressed: () {
                        
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        
                        Icons.camera
                      ),
                     
                      onPressed: () {
                        
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.call_end, color: Colors.red),
                      onPressed: () => Get.back(), // end call
                    ),
                    IconButton(
                      icon: Icon(Icons.cameraswitch),
                      
                      onPressed: () {
                        
                      },
                    ),

                    
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      
    );
  }
}
