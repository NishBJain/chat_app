import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
class ConversationScreen extends StatefulWidget{
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}
class _ConversationScreenState extends State<ConversationScreen>{
  DatabaseMethos databaseMethos = new DatabaseMethos();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessagesStream;
  Widget ChatMessageList(){
return StreamBuilder(stream: chatMessagesStream,
builder: (context, snapshot ){
return snapshot.hasData ? ListView.builder(
  itemCount: snapshot.data.documents.length,
  itemBuilder: (context , index){
    return MessageTile(snapshot.data.documents[index].data["message"],
    snapshot.data.documents[index].data["sendBy"] == Constants.myName);
  }) : Container();
  },
);
  }
  sendMessage(){
    if(messageController.text.isNotEmpty){
  Map<String,dynamic> messageMap = {
      "message" : messageController.text,
      "sendBy" : Constants.myName,
      "time" : DateTime.now().millisecondsSinceEpoch
    };
  databaseMethos.addConversationMessages(widget.chatRoomId, messageMap);
  messageController.text="";
    }
  
  }
  @override
  void initState() {
    databaseMethos.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: <Widget>[
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
                          child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                color: Color(0xFF455A64),
               
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController ,
                        style: simpleTextStyle(),
                        decoration: InputDecoration(
                          hintText: "Message.....",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        
                        sendMessage();
                      },
                      child: Container(
                        height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                   const Color(0xFF0D47A1),
                                    const Color(0xFFBBDEFB)
                              ],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight
                            ),
                            borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png",
                            height: 25, width: 25,)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 20, right :  isSendByMe ? 20 :  0),
      margin:  EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical : 16),
            decoration: BoxDecoration(
              gradient : LinearGradient(colors: isSendByMe ? [
                const Color(0xFFF50057),
                const Color(0xff2A75BC)
              ]
              : [
               const Color(0xFF76FF03),
                const Color(0xff2A75BC)
              ]
              ),
              borderRadius: isSendByMe ? 
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
              ) : BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)
              )
            ),
        child: Text(message , style: TextStyle(
      color: Colors.white,
      fontSize : 18
  ),),
      ),
    );
  }
}