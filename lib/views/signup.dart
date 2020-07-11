import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatRoomScreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
   final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethos databaseMethos=new DatabaseMethos();

   final formKey = GlobalKey<FormState>();
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
 
 signMeUp(){
   if(formKey.currentState.validate()){
     Map<String,String> userInfoMap = {
                "name" : usernameEditingController.text,
                "email" : emailEditingController.text
              };
    HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);
    HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text); 
     
    setState(() {
      isLoading = true;
    });
    authMethods.signUpWithEmailAndPassword(emailEditingController.text,passwordEditingController.text).then((val){
     //print("${val.userId}");
      

databaseMethos.uploadUserInfo(userInfoMap);
HelperFunctions.saveUserLoggedInSharedPreference(true); 
      Navigator.pushReplacement( context, MaterialPageRoute(
        builder: (context)=> ChatRoom()
        ));
     });
   }
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator( )),
      ) :SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height-60,
          alignment: Alignment.bottomCenter,
                child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
               Form(
                 key: formKey,
                                child: Column(
                   children: [
                      TextFormField(
                         validator: (val){
                      return val.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
                    },
                    controller:usernameEditingController ,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("Username"),
                  ),
                  TextFormField(
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Enter correct email";
                    },
                    controller: emailEditingController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("email"),
                  ),
                  TextFormField(
                    obscureText: true,
                     validator:  (val){
                      return val.length < 6 ? "Enter Password 6+ characters" : null;
                    },
                    controller: passwordEditingController,
                     style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("password"),
                  ),
                   ],
                 ),
               ),
                SizedBox(height: 8,),
               Container(
                 alignment: Alignment.centerRight,
                 child:  Container(
                  padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                  child:Text(
                                  "Forgot Password?",
                                  style: simpleTextStyle(),
                                ),
                ),
               ),
               SizedBox(height: 8,),
               GestureDetector(
                 onTap: (){
                    signMeUp();
                 },
                                child: Container(
                   alignment: Alignment.center,
                   width: MediaQuery.of(context).size.width,
                   padding: EdgeInsets.symmetric(vertical: 16),
                   decoration: BoxDecoration(
                     gradient: LinearGradient(
                       colors:
                        [
                                 const Color(0xFF0D47A1),
                                  const Color(0xFFBBDEFB)
                                  ],
                                   ),
                                   borderRadius: BorderRadius.circular(30),
                   ),
                   child: Text("Sign Up", style: TextStyle(
                     color: Colors.white,
                     fontSize:17
                   ),),
                 ),
               ),
               SizedBox(height: 10,),
                GestureDetector(
                    onTap: (){
                    signMeUp();
                 },
                                  child: Container(
                   alignment: Alignment.center,
                   width: MediaQuery.of(context).size.width,
                   padding: EdgeInsets.symmetric(vertical: 16),
                   decoration: BoxDecoration(
                     color: Colors.white,
                                   borderRadius: BorderRadius.circular(30),
                   ),
                   child: Text("Sign Up with Google", style: TextStyle(
                     color: Colors.black,
                     fontSize:17
                   ),),
               ),
                ),
               SizedBox(
                        height: 16,
                      ),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have account ?",
                            style: simpleTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "SignIn now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 200,),

              ],
            ),),
        ),
      ),
    );
  }
}