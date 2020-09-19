import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/quizroute.dart';
import 'package:my_flutter_app/userinfo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(MyApp());
  // WidgetsFlutterBinding.ensureInitialized();
  // _areDetailsSaved().then((value) {
  //   if (value == true) {
  //     runApp(UserInfo());
  //   } else {
  //     runApp(MyApp());
  //   }
  // });
}

Future<bool> _areDetailsSaved() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool("info_saved");
}

Future<bool> _saveDetails(
    String _firstName, String _lastName, String _nickName, String _age) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("info_saved", true);
  prefs.setString("First_name", _firstName);
  prefs.setString("Last_name", _lastName);
  prefs.setString("Nickname", _nickName);
  prefs.setString("Age", _age);
  return prefs.commit();
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = "", _lastName = "", _nickName = "", _age = "", score="";


  Future<bool> _getDetails() async {
    final prefs = await SharedPreferences.getInstance();
    _firstName = prefs.getString("First_name") ?? "";
    _lastName = prefs.getString("Last_name") ?? "";
    _nickName = prefs.getString("Nickname") ?? "";
    _age = prefs.getString("Age") ?? "";
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    print(path);
    File _localFile = File('$path/score.txt');
    String scoreFromFile = await _localFile.readAsString();
    if(scoreFromFile!=null){
        score = "Your score was $scoreFromFile";
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  //  _getScore() async{
  //   final directory = await getApplicationDocumentsDirectory();
  //   String path = directory.path;
  //   print(path);
  //   File _localFile = File('$path/score.txt');
  //   String score = await _localFile.readAsString();
  //   if(score!=null){
  //     setState(() {
  //       score = "Your score was $score";
  //     });
  //   }
  //   print(score);
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Quiz"),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder(
          future: _getDetails(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Enter First (given) name"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _firstName = value;
                          },
                          initialValue: "$_firstName",
                        ),
                        TextFormField(
                          initialValue: "$_lastName",
                          decoration: InputDecoration(
                              labelText: "Enter your Family (last) name"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter family name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _lastName = value;
                          },
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: "Enter your Nickname"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter nickname';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _nickName = value;
                          },
                          initialValue: "$_nickName",
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration:
                              InputDecoration(labelText: "Enter your age"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter age';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _age = value;
                          },
                          initialValue: "$_age",
                        ),
                        Builder(
                          builder: (context) => Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        print("Button pressed");
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          _saveDetails(_firstName, _lastName,
                                                  _nickName, _age)
                                              .then((value) {
                                            final snackBar = SnackBar(content: Text('Details have been saved!'));
                                            Scaffold.of(context).showSnackBar(snackBar);
                                            // Navigator.pushReplacement(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       builder: (context) => UserInfo()),
                                            // );
                                            // Navigator.pop(context);
                                          });
                                        }
                                      },
                                      child: Text("Done"))),
                              Container(
                                child: ElevatedButton(onPressed: (){
                                  _areDetailsSaved().then((value) {
                                    if(value==true){
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReadQuestions()),
                                      );
                                    }else{
                                      final snackBar = SnackBar(content: Text('Please enter your details.'));
                                      Scaffold.of(context).showSnackBar(snackBar);
                                    }
                                  });

                                },
                                  child: Text("Start Quiz"),
                                ),
                              ),
                              Container(
                                child: Text(score),
                              )
                            ],
                          ),
                        ),
                        // Container(
                        //     padding: EdgeInsets.all(5.0),
                        //     child: ElevatedButton(
                        //         onPressed: () {}, child: Text("Take a Quiz")))
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Center(child: Text("Loading")),
              );
            }
          }),
    ));
  }
}
