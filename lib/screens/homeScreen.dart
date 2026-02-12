import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videocall_app/controllers/storageService.dart';
import 'package:videocall_app/controllers/homeController.dart';
import 'package:videocall_app/reusable/showDialog.dart';

class HomeScreen extends GetView<Homecontroller> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
  
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => controller.isSearch.value
              ? Row(
                  children: [
                    SizedBox(
                      width: width * 0.7,
                      child: TextField(
                        onChanged: (value) {
                          controller.searchContactList.value = controller
                              .contacts
                              .where((contact) {
                                final name = (contact.displayName ?? 'Unknown')
                                    .toLowerCase();
                                final phone = contact.phones.isNotEmpty
                                    ? contact.phones.first.number.toLowerCase()
                                    : '';
                                final query = value.toLowerCase();
                                return name.contains(query) ||
                                    phone.contains(query);
                              })
                              .toList();
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter name or phone no.',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.1,
                      child: IconButton(
                        onPressed: () => controller.searchContact(),
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text('Contacts'),
                    Spacer(),
                    IconButton(
                      onPressed: () => controller.searchContact(),
                      icon: Icon(Icons.search),
                    ),
                    IconButton(
                      onPressed: () => Get.find<showDialogBoxController>().show(),
                      icon: Icon(Icons.person),
                    )
                  ],
                ),
        ),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.isSearch.value
              ? controller.searchContactList.length
              : controller.contacts.length,
          itemBuilder: (context, index) {
            final contact = controller.isSearch.value
                ? controller.searchContactList[index]
                : controller.contacts[index];

            return ListTile(
              leading: contact.photoOrThumbnail != null
                  ? CircleAvatar(
                      backgroundImage: MemoryImage(contact.photoOrThumbnail!),
                    )
                  : CircleAvatar(child: Icon(Icons.person)),
              title: Text(contact.displayName),
              subtitle: contact.phones.isNotEmpty
                  ? Text(contact.phones.first.number)
                  : null,
              trailing: CircleAvatar(
                child: IconButton(
                  icon: Icon(Icons.videocam),
                  onPressed: () {
                    var hasSelfData = Get.find<StorageService>().hasUserData;
                    // print(hasSelfData);
                    if(hasSelfData){
                        Get.toNamed('/loadingScreen',arguments: {
                      'name' : contact.displayName,
                      'phone': contact.phones.first.number,
                    });
                    }else{
                     Get.find<showDialogBoxController>().show();
                    }
                    
                  
                  },
                  color: Colors.green,
                ),
              ),
            );
          },
        ), 
      ),
    );
  }
}
