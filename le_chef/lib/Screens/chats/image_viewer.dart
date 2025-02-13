import 'package:flutter/material.dart';
import 'package:le_chef/Screens/chats/chatPage.dart';

import '../../Models/group.dart';

class ImageViewerDialog extends StatelessWidget {
  final String imageUrl;
  final Group? group;
  final String? receiverId;
  final String? receiverName;
  final String? chatRoom;
  final bool person;
  final String? imgUrl;


  const ImageViewerDialog({Key? key, required this.imageUrl, this.group, this.receiverId, this.receiverName, this.chatRoom, required this.person, this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () =>{
            Navigator.pop(context),
            Navigator.pop(context),
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(person: person, imgUrl: imgUrl, group: group, receiverId: receiverId, receiverName: receiverName, chatRoom: chatRoom,)))
  }
        ),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}