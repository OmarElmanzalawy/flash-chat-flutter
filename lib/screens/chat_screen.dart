import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController textEditingController = TextEditingController();
  late User currentUser;
  String? messagetxt;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser()async{
    try {
      final user = await _auth.currentUser;
      if(user!= null){
        currentUser = user;
      }
    } catch (e) {
      print('Error occured while getting current user');
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
              onPressed: () {
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
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context,  snapshot){
                List<Widget> messageWidgets = [];
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(value: null));
                }
                //TODO: FIX THIS SHIT
                else if(snapshot.hasData){
                  final messages = snapshot.data!.docs.reversed;
                  for(var message in messages){

                    final mappedText = message.data() as Map<String,dynamic>;
                    final text = mappedText['text'];
                    final mappedSender = message.data() as Map<String,dynamic>;
                    final sender = mappedSender['sender'];
                    final messageWidget = 
                    messageWidgets.add(MessageBubble(sender: sender,text: text,isMe: sender == currentUser.email,));
                  }
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                    children: messageWidgets
                    ),
                );
              }
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
                        messagetxt = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.collection('messages').add(
                        {
                          'sender':currentUser.email,
                          'text': messagetxt,
                        });
                        textEditingController.clear();
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
    
    MessageBubble({this.sender,this.text,this.isMe});
    
    final String? sender;
    final String? text;
    final bool? isMe;

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          crossAxisAlignment:isMe! ? CrossAxisAlignment.end: CrossAxisAlignment.start,
          children: [
            Text(
              sender!,
              style: TextStyle(fontSize: 12),
              ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: isMe! ? BorderRadius.only(bottomLeft: Radius.circular(30),topLeft: Radius.circular(30),bottomRight: Radius.circular(30)) :
                BorderRadius.only(bottomLeft: Radius.circular(30),topRight: Radius.circular(30),bottomRight: Radius.circular(30))
              ),
              color: isMe! ? Colors.lightBlueAccent : Colors.grey,
              elevation: 20,
              
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                  '$text',
                  style: kmessageTextStyle,                      
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
