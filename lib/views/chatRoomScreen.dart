import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/status_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'groupCall.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethos databaseMethos = new DatabaseMethos();
  Stream chatRoomsStream;
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                      snapshot.data.documents[index].data["chatroomid"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      snapshot.data.documents[index].data["chatroomid"]);
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethos.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {});
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
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: "Call",
                child: Row(
                  children: <Widget>[
                    Icon(Icons.video_call),
                    SizedBox(width: 10,),
                    Text("Group Call"),
                  ],
                ),
              ),

              PopupMenuItem<String>(
                value: "LogOut",
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 10,),
                    Text("LogOut"),
                  ],
                ),
              ),
            ],
            onSelected: (retVal){
              if(retVal=="Call") {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => IndexPage()));
              }
              else if(retVal == "LogOut"){
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              }
            },
          ),
          //GestureDetector(
            //onTap: () {
              //authMethods.signOut();
              //Navigator.pushReplacement(context,
                //  MaterialPageRoute(builder: (context) => Authenticate()));
            //},
            //child: Container(
              //  padding: EdgeInsets.symmetric(horizontal: 16),
                //child: Icon(
                  //Icons.exit_to_app,
                  //color: Colors.blue,
                //)),
          //)
        ],
      ),
        body: chatRoomList(),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                heroTag: 1,
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SearchScreen()));
                },
                child: Icon(Icons.search),
              ),
              FloatingActionButton(
                heroTag: 2,
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => StatusScreen()));
                },
                child: Icon(Icons.play_circle_filled),
              )
            ],
          ),
        )
      //floatingActionButton: FloatingActionButton(
      //children:<Widget> [
      // FloatingActionButton(
      //onPressed: () {
      //Navigator.push(
      //context, MaterialPageRoute(builder: (context) => SearchScreen()));
      //},
      //child:Icon(Icons.search),),
      // FloatingActionButton(onPressed: (){},
      // child: Icon(Icons.search),
      //  )
      //  ],
      //),

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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.grey[700], borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(30)),
              child: Text("${userName.substring(0, 1).toUpperCase()}"),
            ),
            SizedBox(width: 30,),
            Text(
              userName,
              style: mediumTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
