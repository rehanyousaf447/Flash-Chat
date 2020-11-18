import 'package:flutter/material.dart';
import 'package:flash_chatt/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chatscreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  final _firestore = FirebaseFirestore.instance;
  String textmessages;
  Timestamp date;
  TextEditingController textEditingController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //TODO: STEP 5 make stream builder add stream and builder property
            StreamBuilder(
              stream: _firestore.collection("messages").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data.docs;
                  List<MessageBubble> messageBubble = [];
                  final currentUser = loggedInUser.email;
                  for (var message in messages) {
                    final textMessage = message.data()['text'];
                    final sender = message.data()['Sender'];
                    final currenttime=message.data()['date'];

                    messageBubble.add(MessageBubble(
                      sender: sender,
                      textMessage: textMessage,
                      isMe: currentUser == sender,
                      mytime: currenttime,
                    ));
                  }
                  messageBubble.sort((a, b) {
                    return b.mytime.compareTo(a.mytime);
                  });
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
                      children: messageBubble,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        textmessages = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      date=Timestamp.now();
                      textEditingController.clear();
                      _firestore.collection("messages").add(
                          {'text': textmessages, 'Sender': loggedInUser.email,
                          'date':date});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.textMessage, this.isMe,this.mytime});
  final String textMessage;
  final String sender;
  final bool isMe;
  final Timestamp mytime;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(sender),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Material(
            elevation: 6.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                "$textMessage",
                style: TextStyle(
                    fontSize: 18.0,
                    color: isMe ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class MessageStream extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection("messages").snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(
//               backgroundColor: Colors.lightBlueAccent,
//             ),
//           );
//         }
//         if (snapshot.hasData) {
//           final messages = snapshot.data.docs.reversed;
//           List<MessageBubble> messageBubble = [];
//           for (var message in messages) {
//             final messageText = message.data()['text'];
//             final sender = message.data()['email'];
//
//             final currentUser = loggedInUser.email;
//
//             if (currentUser == sender) {}
//
//             messageBubble.add(
//               MessageBubble(
//                 messageText: messageText,
//                 sender: sender,
//                 isMe: currentUser == sender,
//               ),
//             );
//           }
//           return Expanded(
//             child: ListView(
//               reverse: true,
//               padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//               children: messageBubble,
//             ),
//           );
//         } else {
//           return null;
//         }
//       },
//     );
//   }
// }
//
// class MessageBubble extends StatelessWidget {
//   MessageBubble({this.messageText, this.sender, this.isMe});
//
//   final String messageText;
//   final String sender;
//   final bool isMe;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment:
//           isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         Text(
//           sender,
//           style: TextStyle(
//             fontSize: 12.0,
//             color: Colors.black54,
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.all(10.0),
//           child: Material(
//             borderRadius: isMe
//                 ? BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                     topLeft: Radius.circular(30),
//                   )
//                 : BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//             elevation: 6.0,
//             color: isMe ? Colors.lightBlueAccent : Colors.white,
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//               child: Text(
//                 "$messageText",
//                 style: TextStyle(
//                     fontSize: 15.0,
//                     color: isMe ? Colors.white : Colors.black54),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
