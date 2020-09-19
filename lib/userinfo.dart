import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String _firstName, _lastName, _nickName;
  int _age;
  @override
  void initState() {
    _getDetails();
    super.initState();
  }
 _getDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString("First_name");
      _lastName = prefs.getString("Last_name");
      _nickName = prefs.getString("Nickname");
      _age = prefs.getInt("Age");
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: AppBar(
              centerTitle: true,
              title: Text("User Details"),
              backgroundColor: Colors.red,
            ),
            body: Center(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            //color: Colors.grey,
                            padding: EdgeInsets.all(5.0),
                              child: Text("First Name: ",
                              style: TextStyle(
                                  fontSize: 18.0,
                                fontWeight: FontWeight.bold
                              ))
                          ),
                        ),
                        Expanded(
                          child: Container(
                              //color: Colors.grey,
                              padding: EdgeInsets.all(5.0),
                              child: Text("$_firstName",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  )
                              )
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              //color: Colors.grey,
                              padding: EdgeInsets.all(5.0),
                              child: Text("Last Name: ",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  ))
                          ),
                        ),
                        Expanded(
                          child: Container(
                            //color: Colors.grey,
                              padding: EdgeInsets.all(5.0),
                              child: Text("$_lastName",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  )
                              )
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              //color: Colors.grey,
                              padding: EdgeInsets.all(5.0),
                              child: Text("Nickname: ",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  ))
                          ),
                        ),
                        Expanded(
                          child: Container(
                            //color: Colors.grey,
                              padding: EdgeInsets.all(5.0),
                              child: Text("$_nickName",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  )
                              )
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,

                              //color: Colors.grey,
                              padding: EdgeInsets.all(5.0),
                              child: Text("Age: ",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  ))
                          ),
                        ),
                        Expanded(
                          child: Container(
                            //color: Colors.grey,
                              padding: EdgeInsets.all(5.0),
                              child: Text("$_age",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  )
                              )
                          ),
                        )
                      ],
                    ),
                    Builder(
                      builder: (context)=> Container(
                        margin: EdgeInsets.all(10.0),
                        child: ElevatedButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                          );
                        },
                          child: Text("Edit"),
                        ),
                      ),
                    ),
                    Container(
                      child: ElevatedButton(onPressed: (){
                      },
                        child: Text("Start Quiz"),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
