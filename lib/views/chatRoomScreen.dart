import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethos databaseMethos = new DatabaseMethos();
  Stream chatRoomsStream;
  Widget chatRoomList(){
    return StreamBuilder(stream: chatRoomsStream ,
    builder: (context , snapshot){
      return snapshot.hasData ? ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context , index){
          return ChatRoomTile(
            snapshot.data.documents[index].data["chatroomid"].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
            snapshot.data.documents[index].data["chatroomid"]
          );
        }) : Container();
    },
    );
  }
  @override
  void initState() {
    getUserInfo();
    
    super.initState();
  }

  getUserInfo()async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethos.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.jpeg",
          height: 40,
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app, color: Colors.blue,)),
          )
        ],
      ),
      body: chatRoomList(),
       floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      
    );
  }
}
class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen(chatRoomId)
        ));
      },
          child: Container(
            margin: EdgeInsets.symmetric(vertical : 3),
             decoration: BoxDecoration(
                gradient: LinearGradient(
                         colors:
                          [
                                      const Color(0xFFF44336),
                                      const Color(0xFF03A9F4),
                                      
                                    ],
                                     ),
                                     borderRadius: BorderRadius.circular(30)
              ),
        padding: EdgeInsets.symmetric(horizontal : 24, vertical : 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
               decoration: BoxDecoration(
                gradient: LinearGradient(
                         colors:
                          [
                                      const Color(0xFF0D47A1),
                                      const Color(0xFFBBDEFB)
                                    ],
                                     ),
                                     borderRadius: BorderRadius.circular(30)
              ),
               child:  Text("${userName.substring(0,1).toUpperCase()}"),
              ),
           
           
            SizedBox(width: 8,),
            Text(userName, style: mediumTextStyle(),)
          ],
        ),
      ),
    );
  }
}