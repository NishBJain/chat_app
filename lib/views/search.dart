import 'package:chat_app/helper/constants.dart';

import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'conversation_screen.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
String _myName;
class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethos databaseMethos = new DatabaseMethos();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot;
  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
      shrinkWrap: true,
      itemCount:searchSnapshot.documents.length ,
        itemBuilder: (context, index){
        return SearchTile(
          userName: searchSnapshot.documents[index].data["name"],
          userEmail: searchSnapshot.documents[index].data["email"],
        );
        }) : Container();
  }
  initiateSearch(){
    databaseMethos.getUserByUsername(searchTextEditingController.text).then((val){
                        setState(() {
                          searchSnapshot = val;
                        });
                      });
  }
 createChatroomAndStartConversation({String userName}){
   print("${Constants.myName}");
    if(userName != Constants.myName){
      String chatroomid =getChatRoomId(userName, Constants.myName);
    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users" : users,
      "chatroomid" : chatroomid
    };
    DatabaseMethos().createChatRoom(chatroomid, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(
      chatroomid
    )
    ));
    }
    else{
      print("you cannot send message to yourself");
    }
  }
  Widget SearchTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical:16),
      child: Row(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(userName, style: simpleTextStyle(),),
            Text(userEmail, style: simpleTextStyle(),)
          ]
        ),
        Spacer(),
        GestureDetector(
          onTap: (){
  createChatroomAndStartConversation(
    userName: userName
  );

          },
                  child: Container(
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            
            child: Text("Message",style: simpleTextStyle(),), 
          ),
        )
      ],)
    );
  }
  @override
  void initState() {
    
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              color: Color(0xFF455A64),
             
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: simpleTextStyle(),
                      decoration: InputDecoration(
                        hintText: "search username ...",
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
                      
                      initiateSearch();
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
                        child: Image.asset("assets/images/search_white.png",
                          height: 25, width: 25,)),
                  )
                ],
              ),
            ),
          searchList()

        ],)
      ),
    );
  }
}
 getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }